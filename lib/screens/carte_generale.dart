import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:mysql1/mysql1.dart' hide Row;
import 'package:flutter_session/flutter_session.dart';


import 'package:firebase_database/firebase_database.dart';
import 'package:login_dash_animation/widgets/headerWidget.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

class carte_generale extends StatefulWidget {
  @override
  carte_generaleState createState() => carte_generaleState();
}

const bleu = const Color(0xFFF21618C);
const bleu2 = const Color(0xFFF1f94aa);

class carte_generaleState extends State<carte_generale> {
  var session = FlutterSession();
  MapboxMapController mapboxMapController;
  final databaseReference = FirebaseDatabase.instance.reference().child("Panneau");




  @override
  void initState() {
    super.initState();
  }


loadPostions(MapboxMapController controller){

  databaseReference.once().then((DataSnapshot snapshot){
    Map<dynamic, dynamic> values = snapshot.value;
    values.forEach((key,value) {
      var point = LatLng(double.parse(value['lat'].toString()), double.parse(value['lng'].toString()));
      print(value['lat'].toString()+','+ value['lng'].toString()+'*******************************');
      mapboxMapController.addSymbol(SymbolOptions(

        geometry: point,
        iconSize: 2,
        iconImage: 'assetImage',

      ));
    });
  });

}
  _onMapCreate(MapboxMapController controller) async{

   this.mapboxMapController = controller;
    await _onStyleLoadedCallback();

  }
  Future<void> _onStyleLoaded() async {
    try{
      await  addImageFromAsset("assetImage", "assets/images/marker.png");

    } on PlatformException catch (err) {
  print('PlatformException: ${err.message} somthing went wrong in add image*************************');
  } catch (err) {
  print('err message: ${err.message} somthing went wrong in add image*************************');
  }
  }
  Future<void> _onStyleLoadedCallback() async {
    // await _onStyleLoaded();

    try {
      await loadPostions(mapboxMapController);
    } on PlatformException catch (err) {
      print('PlatformException: ${err.message}');
    } catch (err) {
      print('err message: ${err.message} somthing went wrong*************************');
    }
  }



  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapboxMapController.addImage(name, list);
  }
  Future<void> addImageFromAsset2(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapboxMapController.addImage(name, list);
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
                        color: bleu2,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          topRight: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          bottomRight: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          bottomLeft: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
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
                          vertical: SizeConfig.safeBlockHorizontal * 6),
                      height: MediaQuery.of(context).size.height * 0.80,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                          Text(" Les panneaux sur Marrakech",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              )),
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.635,
                            child: MapboxMap(

                              onMapCreated: _onMapCreate,
                              onStyleLoadedCallback: _onStyleLoaded,

                              initialCameraPosition: CameraPosition(
                                  zoom: 12,
                                  target: LatLng(31.620717, -7.985883)),
                            ),

                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
