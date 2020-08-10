import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final Widget icon;
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final bool enabled;

  const CustomTextField(
      {Key key, this.label, this.icon, this.controller, this.isPassword = false,this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextField(
      enabled: enabled,
          controller: controller,
      style: TextStyle(color: Color(0xFFF234253), fontWeight: FontWeight.bold),
      obscureText: isPassword,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: BorderSide(color: Color(0xFFF1A5276 ), width: 1.0)
          ),

          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

              borderSide: BorderSide(color: Color(0xFFF1A5276 ), width: 1.0)
          ),
          labelText: label,

          labelStyle: TextStyle(
              color: Color(0xFFF234253), fontWeight: FontWeight.bold),
          suffixIcon: icon
      ),

    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextEditingController>(
        'controller', controller, defaultValue: null));
  }

}
class _TextFieldState extends State<TextField> implements TextSelectionGestureDetectorBuilderDelegate {
  TextEditingController _controller;
  TextEditingController get _effectiveController => widget.controller ?? _controller;

  FocusNode _focusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  bool _isHovering = false;

  bool get needsCounter => widget.maxLength != null
      && widget.decoration != null
      && widget.decoration.counterText == null;

  bool _showSelectionHandles = false;



  // API for TextSelectionGestureDetectorBuilderDelegate.
  @override
  bool forcePressEnabled;

  @override
  final GlobalKey<EditableTextState> editableTextKey = GlobalKey<EditableTextState>();

  @override
  bool get selectionEnabled => widget.selectionEnabled;
  // End of API for TextSelectionGestureDetectorBuilderDelegate.

  bool get _isEnabled =>  widget.enabled ?? widget.decoration?.enabled ?? true;

  int get _currentLength => _effectiveController.value.text.runes.length;

  InputDecoration _getEffectiveDecoration() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final ThemeData themeData = Theme.of(context);
    final InputDecoration effectiveDecoration = (widget.decoration ?? const InputDecoration())
        .applyDefaults(themeData.inputDecorationTheme)
        .copyWith(
      enabled: widget.enabled,
      hintMaxLines: widget.decoration?.hintMaxLines ?? widget.maxLines,
    );

    // No need to build anything if counter or counterText were given directly.
    if (effectiveDecoration.counter != null || effectiveDecoration.counterText != null)
      return effectiveDecoration;

    // If buildCounter was provided, use it to generate a counter widget.
    Widget counter;
    final int currentLength = _currentLength;
    if (effectiveDecoration.counter == null
        && effectiveDecoration.counterText == null
        && widget.buildCounter != null) {
      final bool isFocused = _effectiveFocusNode.hasFocus;
      final Widget builtCounter = widget.buildCounter(
        context,
        currentLength: currentLength,
        maxLength: widget.maxLength,
        isFocused: isFocused,
      );
      // If buildCounter returns null, don't add a counter widget to the field.
      if (builtCounter != null) {
        counter = Semantics(
          container: true,
          liveRegion: isFocused,
          child: builtCounter,
        );
      }
      return effectiveDecoration.copyWith(counter: counter);
    }

    if (widget.maxLength == null)
      return effectiveDecoration; // No counter widget

    String counterText = '$currentLength';
    String semanticCounterText = '';

    // Handle a real maxLength (positive number)
    if (widget.maxLength > 0) {
      // Show the maxLength in the counter
      counterText += '/${widget.maxLength}';
      final int remaining = (widget.maxLength - currentLength).clamp(0, widget.maxLength) as int;
      semanticCounterText = localizations.remainingTextFieldCharacterCount(remaining);

      // Handle length exceeds maxLength
      if (_effectiveController.value.text.runes.length > widget.maxLength) {
        return effectiveDecoration.copyWith(
          errorText: effectiveDecoration.errorText ?? '',
          counterStyle: effectiveDecoration.errorStyle
              ?? themeData.textTheme.caption.copyWith(color: themeData.errorColor),
          counterText: counterText,
          semanticCounterText: semanticCounterText,
        );
      }
    }

    return effectiveDecoration.copyWith(
      counterText: counterText,
      semanticCounterText: semanticCounterText,
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    _effectiveFocusNode.canRequestFocus = _isEnabled;
  }

  @override
  void didUpdateWidget(TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null)
      _controller = TextEditingController.fromValue(oldWidget.controller.value);
    else if (widget.controller != null && oldWidget.controller == null)
      _controller = null;
    _effectiveFocusNode.canRequestFocus = _isEnabled;
    if (_effectiveFocusNode.hasFocus && widget.readOnly != oldWidget.readOnly) {
      if(_effectiveController.selection.isCollapsed) {
        _showSelectionHandles = !widget.readOnly;
      }
    }
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  EditableTextState get _editableText => editableTextKey.currentState;

  void _requestKeyboard() {
    _editableText?.requestKeyboard();
  }

  bool _shouldShowSelectionHandles(SelectionChangedCause cause) {
    // When the text field is activated by something that doesn't trigger the
    // selection overlay, we shouldn't show the handles either.

    if (cause == SelectionChangedCause.keyboard)
      return false;

    if (widget.readOnly && _effectiveController.selection.isCollapsed)
      return false;

    if (cause == SelectionChangedCause.longPress)
      return true;

    if (_effectiveController.text.isNotEmpty)
      return true;

    return false;
  }

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);
    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        if (cause == SelectionChangedCause.longPress) {
          _editableText?.bringIntoView(selection.base);
        }
        return;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      // Do nothing.
    }
  }

  /// Toggle the toolbar when a selection handle is tapped.
  void _handleSelectionHandleTapped() {
    if (_effectiveController.selection.isCollapsed) {
      _editableText.toggleToolbar();
    }
  }

  void _handleHover(bool hovering) {
    if (hovering != _isHovering) {
      setState(() {
        _isHovering = hovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    // TODO(jonahwilliams): uncomment out this check once we have migrated tests.
    // assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    assert(
    !(widget.style != null && widget.style.inherit == false &&
        (widget.style.fontSize == null || widget.style.textBaseline == null)),
    'inherit false style must supply fontSize and textBaseline',
    );

    final ThemeData themeData = Theme.of(context);
    final TextStyle style = themeData.textTheme.subtitle1.merge(widget.style);
    final Brightness keyboardAppearance = widget.keyboardAppearance ?? themeData.primaryColorBrightness;
    final TextEditingController controller = _effectiveController;
    final FocusNode focusNode = _effectiveFocusNode;



    TextSelectionControls textSelectionControls;
    bool paintCursorAboveText;
    bool cursorOpacityAnimates;
    Offset cursorOffset;
    Color cursorColor = widget.cursorColor;
    Radius cursorRadius = widget.cursorRadius;

    switch (themeData.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        forcePressEnabled = true;

        paintCursorAboveText = true;
        cursorOpacityAnimates = true;

        cursorRadius ??= const Radius.circular(2.0);
        cursorOffset = Offset(iOSHorizontalOffset / MediaQuery.of(context).devicePixelRatio, 0);
        break;

      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        forcePressEnabled = false;
        textSelectionControls = materialTextSelectionControls;
        paintCursorAboveText = false;
        cursorOpacityAnimates = false;
        cursorColor ??= Color(0xFFF1A5276 );
        break;
    }

    Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        readOnly: widget.readOnly,
        toolbarOptions: widget.toolbarOptions,
        showCursor: widget.showCursor,
        showSelectionHandles: _showSelectionHandles,
        controller: controller,
        focusNode: focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        style: style,
        strutStyle: widget.strutStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        autofocus: widget.autofocus,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        enableSuggestions: widget.enableSuggestions,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        selectionColor: themeData.textSelectionColor,
        selectionControls: widget.selectionEnabled ? textSelectionControls : null,
        onChanged: widget.onChanged,
        onSelectionChanged: _handleSelectionChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        onSelectionHandleTapped: _handleSelectionHandleTapped,

        rendererIgnoresPointer: true,
        cursorWidth: widget.cursorWidth,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,

        scrollPadding: widget.scrollPadding,
        keyboardAppearance: keyboardAppearance,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        dragStartBehavior: widget.dragStartBehavior,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
      ),
    );

    if (widget.decoration != null) {
      child = AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[ focusNode, controller ]),
        builder: (BuildContext context, Widget child) {
          return InputDecorator(
            decoration: _getEffectiveDecoration(),
            baseStyle: widget.style,
            textAlign: widget.textAlign,
            textAlignVertical: widget.textAlignVertical,
            isHovering: _isHovering,
            isFocused: focusNode.hasFocus,
            isEmpty: controller.value.text.isEmpty,
            expands: widget.expands,
            child: child,
          );
        },
        child: child,
      );
    }
    return IgnorePointer(
      ignoring: !_isEnabled,
      child: MouseRegion(

        child: AnimatedBuilder(
          animation: controller, // changes the _currentLength
          builder: (BuildContext context, Widget child) {
            return Semantics(
              maxValueLength: widget.maxLengthEnforced && widget.maxLength != null && widget.maxLength > 0
                  ? widget.maxLength
                  : null,
              currentValueLength: _currentLength,
              onTap: () {
                if (!_effectiveController.selection.isValid)
                  _effectiveController.selection = TextSelection.collapsed(offset: _effectiveController.text.length);
                _requestKeyboard();
              },
              child: child,
            );
          },

        ),
      ),
    );
  }
}