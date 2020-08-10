import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login_dash_animation/screens/carte_generale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/animations/fadeAnimation.dart';
import 'package:login_dash_animation/animations/color_loader.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

//const bleu = const Color(0xFFF21618C);

const bleu = const Color(0xFFF1f94aa);

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Timer _timer;
  FlutterLogoStyle _logoStyle = FlutterLogoStyle.markOnly;
  FadeIn() {
    _timer = new Timer(const Duration(seconds: 2), () {
      setState(() {
        _logoStyle = FlutterLogoStyle.horizontal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => carte_generale())));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 10,
                vertical: SizeConfig.safeBlockHorizontal * 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: bleu,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: SizeConfig.safeBlockHorizontal * 17),
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 4,
                      top: SizeConfig.safeBlockHorizontal * 20),
                  child: FadeAnimation(
                      2.6,
                      Text("Detection des Panneaux",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                          ))),
                ),
                Container(
                  width: SizeConfig.safeBlockHorizontal * 50,
                  height: SizeConfig.safeBlockHorizontal * 50,
                  child: FadeAnimation(
                      2.6, Image.asset("assets/images/iconesp.png")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
