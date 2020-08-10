import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:mysql1/mysql1.dart' hide Row;
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'dart:io'  ;
import 'package:async/async.dart';
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


  @override
  void initState() {
    super.initState();

  }

  _onMapCreate(MapboxMapController controller){
    mapboxMapController=controller;
  }
  static Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'shuttle.myguide.ma', user: 'myguidem', password: 'aqJ6gVU;6O79-y',db: 'myguidem_taxiapp'));
    return conn;
  }

  @override
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

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
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                          Text(" Titre du Panneau", style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,


                          )),
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 7),

                          Container(
                              height: MediaQuery.of(context).size.height * 0.635,
                              child:MapboxMap(

                                onMapCreated: _onMapCreate,
                                initialCameraPosition:
                                const CameraPosition(
                                    zoom: 13,
                                    target: LatLng(31.620717, -7.985883)),
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
