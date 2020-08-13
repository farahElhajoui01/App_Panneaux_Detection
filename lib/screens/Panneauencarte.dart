import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:login_dash_animation/widgets/headerWidget.dart';
import 'package:mapbox_gl/mapbox_gl.dart';



class panneauencarte extends StatefulWidget {

  @override
  panneauencarteState createState() => panneauencarteState();
}
const bleu = const Color(0xFFF21618C);
const bleu2 = const Color(0xFFF1f94aa);

//const bleu2=const Color(0xFFF1A5276 );

class panneauencarteState extends State<panneauencarte> {


  var session = FlutterSession();
  MapboxMapController mapboxMapController;
  String titre='Titre du Panneau';
  var lat;
  var lng;
  // à decommenter après
  // var point = LatLng(lat,lng);

  //ces valeurs pour le test ,à commenter après
  var point = LatLng(31.644044, -8.004617);
//ce code à mettre dans le button 'voir' dans panneaux-list remplaçer ? par les vraies valeurs!
  //Navigator.pushNamed(context, "Panneauencarte",arguments: {"titre" : ?, "lat": ?,"lng": ?});},


  @override
  void initState() {
    super.initState();

  }

  _onMapCreate(MapboxMapController controller) async{
    this.mapboxMapController=controller;

    await _onStyleLoadedCallback();
  }
  void _onStyleLoaded() {

    addImageFromAsset("assetImage2", "assets/images/marker2.png");
  }
  void _onStyleLoadedCallback() async {
    try {
      //await loadPostions(mapboxMapController);
    } on PlatformException catch (err) {
      print('PlatformException: ${err.message}');
    } catch (err) {
      print('err message: ${err.message} somthing went wrong*************************');
    }
  }
  loadPostions(MapboxMapController mapboxMapController) async{
    await _onStyleLoaded();

    if(mapboxMapController==null)
      print('controller isnull');
    else
    mapboxMapController.addSymbol(SymbolOptions(
      geometry: point,
      iconSize: 3,
      iconImage: 'assetImage2',
    ));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapboxMapController.addImage(name, list);
  }

  @override
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    //à décommenter et tester
    /* final  Map<String, Object>data = ModalRoute.of(context).settings.arguments;
    setState(() {
      titre = data['titre'];
      lat=data['lat'];
      lng=data['lng'];
    });
    print("data ${data['titre']} ${data['lat']} ${data['lng']}");
   */
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[


          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,


          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(


                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  HeaderWidget(),

                  Container(

                      decoration: BoxDecoration(
                        color:bleu2,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 7),
                          topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 7),
                          bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 7),
                          bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 7),

                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.safeBlockHorizontal * 4,
                          vertical: SizeConfig.safeBlockHorizontal *6),

                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left : SizeConfig.safeBlockHorizontal * 3,
                            top: SizeConfig.safeBlockHorizontal * 2),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: <Widget>[
                            Text(titre, style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,


                            )),
                            SizedBox(width: SizeConfig.safeBlockHorizontal * 3),

                            RaisedButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Color(0xFFF032f41),width: 0.3)),
                                child:Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: <Widget>[
                                    SizedBox(width: SizeConfig.safeBlockHorizontal * 3),

                                    Center(
                                      child: Text('Voire Position', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,


                                      )),
                                    ),

                                  ],
                                ),
                                onPressed : (){

                                  loadPostions(mapboxMapController);
                                }
                            ),
                          ]),
                      ),

                          SizedBox(height: SizeConfig.safeBlockHorizontal * 5),

                          Container(
                              height: MediaQuery.of(context).size.height * 0.635,
                              child:MapboxMap(

                                onMapCreated: _onMapCreate,
                                initialCameraPosition:
                                CameraPosition(
                                    zoom: 15,
                                    target: point),
                              )

                          ),

                        ],

                      )


                  ),
                ],
              ),),),],),
    );
  }
}