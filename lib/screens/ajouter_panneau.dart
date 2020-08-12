import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:login_dash_animation/components/customTextfield.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/screens/panneaux_list.dart';
import 'package:mysql1/mysql1.dart' hide Row;
import 'package:flutter_session/flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/src/widgets/basic.dart' as row;
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:flutter_session/flutter_session.dart';
import 'package:dio/dio.dart' as dio;

import 'package:firebase_database/firebase_database.dart';
import 'package:login_dash_animation/widgets/headerWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Ajouter_panneau extends StatefulWidget {
  @override
  _Ajouter_panneauState createState() => _Ajouter_panneauState();
}

const bleu = Colors.black;
const bleu2 = const Color(0xFFF1f94aa);

class _Ajouter_panneauState extends State<Ajouter_panneau> {
  final databaseReference = FirebaseDatabase.instance.reference();
  StorageReference storageReference = FirebaseStorage.instance.ref();

  var session = FlutterSession();
  final titr = TextEditingController();
  final description = TextEditingController();
  final client = TextEditingController();
  var dropdownvalue;
  List<String> categories = new List();
  File _image;
  String msg = '';
  var imageColor = Colors.white;
  var titre = 'Image';
  var textcolor = Colors.white;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  var downloadUrl1;
  static int id = 5;

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  ajouter_panneau(String titre, String client, String description,
      String categorie, BuildContext context) async {
    if (titre == "" || client == "" || description == "" || _image == null || categorie=="")
    setState(() {
      msg = 'Veuillez remplir tous les champs!';
    });
    else {
      var cat=categorie.split("-");
      setState(() {
        msg="";
      });
      await getLocation();
      var lat = _locationData.latitude;
      var lng = _locationData.longitude;
      await addImageToFirebase(_image);
      databaseReference.child("Panneau").push().set({
        'id': id,
        'titre': titre,
        'client_description': client,
        'categorie_id':int.parse(cat[0]),
        'client_id':'',
        'Description': description,
        'lat': lat,
        'lng': lng,
        'image_url': downloadUrl1
      });
      var id1=id+1;
      setState(() {
        id = id1;
      });
      addImageToFirebase(_image);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => panneauxList()),
      );
    }
    print('******************************'+msg);
  }
  void createRecord(){

    databaseReference.child("Categorie").child("2").set({
      'id': 2,
      'libelle': 'Panneau de clinique'
    });
   /* databaseReference.child("Categorie").push().set({
      'id': 2,
      'libelle': 'Panneau de clinique'
    });*/
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, height: 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    setState(() {
      _image = compressImg;
    });
  }

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    var _location = await location.getLocation();

    setState(() {
      _locationData = _location;
    });
  }

  addImageToFirebase(File image) async {
    StorageReference ref = storageReference.child("panneaux_images/");
 String imagename='image'+id.toString()+'.jpg';
    StorageUploadTask storageUploadTask =
        ref.child(imagename).putFile(_image);

    if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
      final String url = await ref.getDownloadURL();
      print("The download URL is " + url);
    } else if (storageUploadTask.isInProgress) {
      storageUploadTask.events.listen((event) {
        double percentage = 100 *
            (event.snapshot.bytesTransferred.toDouble() /
                event.snapshot.totalByteCount.toDouble());
        print("THe percentage " + percentage.toString());
      });

      StorageTaskSnapshot storageTaskSnapshot =
          await storageUploadTask.onComplete;
      var url = await storageTaskSnapshot.ref.getDownloadURL();
      setState(() {
        downloadUrl1 = url;
      });

      //Here you can get the download URL when the task has been completed.
      print("Download URL " + downloadUrl1.toString());
    } else {
      //Catch any cases here that might come up like canceled, interrupted
    }
  }

  getCategories() {

    databaseReference..child('Categorie').once().then((DataSnapshot snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,value) {
        categories.add(value['id'].toString()+'-'+value['libelle']);
      });
    });


    /*databaseReference.child('Categorie').once().then((DataSnapshot snapshot) {

      if (snapshot.value.isNotEmpty) {

          snapshot.value.forEach((value) {
            if (value != null) {

              categories.add(value['id'].toString()+'-'+value['libelle']);
              print('**********************************'+value['libelle']);
          }
            else
                        print('value is null');
          });
      } else
        print("no data");
    });*/
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
            color: Color(0xFFFefefef),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  HeaderWidget(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft:
                            Radius.circular(SizeConfig.safeBlockHorizontal * 7),
                        topRight:
                            Radius.circular(SizeConfig.safeBlockHorizontal * 7),
                        bottomRight:
                            Radius.circular(SizeConfig.safeBlockHorizontal * 7),
                        bottomLeft:
                            Radius.circular(SizeConfig.safeBlockHorizontal * 7),
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
                        horizontal: SizeConfig.safeBlockHorizontal * 5,
                        vertical: SizeConfig.safeBlockHorizontal * 7),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 5,
                        vertical: SizeConfig.safeBlockHorizontal * 2),
                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                        Container(
                          child: Center(
                            child: Text("Ajouter un panneau",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: bleu,
                                  fontSize: 30,
                                  fontFamily: "Pacificio",
                                )),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                        Container(
                          height: SizeConfig.safeBlockHorizontal * 15,
                          child: CustomTextField(
                            controller: titr,
                            label: "Titre",
                            icon: Icon(
                              Icons.title,
                              size: 27,
                              color: Color(0xFFF032f41),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 5),
                        /*  RaisedButton(
                          child: Text("UPLOAD"),
                          onPressed:(){
                            upload(_image);
                          },
                        ),*/

                        Container(
                          height: SizeConfig.safeBlockHorizontal * 15,
                          child: CustomTextField(
                            controller: client,
                            label: "Client",
                            icon: Icon(
                              Icons.person_outline,
                              size: 27,
                              color: Color(0xFFF032f41),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 5),
                        Container(
                          height: SizeConfig.safeBlockHorizontal * 15,
                          child: CustomTextField(
                            controller: description,
                            label: "Description",
                            isPassword: false,
                            icon: Icon(
                              Icons.subtitles,
                              size: 27,
                              color: Color(0xFFF032f41),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 5),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              height: SizeConfig.safeBlockHorizontal * 15,
                              width: SizeConfig.safeBlockHorizontal * 43,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.safeBlockHorizontal * 1),
                                margin: EdgeInsets.only(
                                    left: SizeConfig.safeBlockHorizontal * 4,
                                    right: SizeConfig.safeBlockHorizontal * 4),
                                child: DropdownButton<String>(
                                  underline: SizedBox(),
                                  hint: Text("Catégorie ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFFF032f41),
                                        fontSize: 18,
                                        fontFamily: "Pacificio",
                                      )),
                                  isExpanded: true,
                                  value: dropdownvalue,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFFF032f41),
                                  ),
                                  iconSize: 27,
                                  elevation: 20,
                                  onChanged: (String newval) {
                                    setState(() {
                                      dropdownvalue = newval;

                                      print("select:" + dropdownvalue);
                                    });
                                  },
                                  items: categories.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                            Container(
                              width: SizeConfig.safeBlockHorizontal * 35,
                              height: SizeConfig.safeBlockHorizontal * 15,
                              child: RaisedButton(
                                  color: bleu2,
                                  padding:
                                      const EdgeInsets.only(right: 0, left: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                          color: Color(0xFFF1f94aa),
                                          width: 0.3)),
                                  child: row.Row(
                                    children: <Widget>[
                                      Text(titre,
                                          style: TextStyle(
                                            color: textcolor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(
                                          width:
                                              SizeConfig.safeBlockHorizontal *
                                                  2),
                                      Icon(
                                        Icons.add_a_photo,
                                        size: 32,
                                        color: textcolor,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    getImageCamera();
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                        Container(
                          child: Center(
                            child: Text(msg,
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                        Container(
                          height: SizeConfig.safeBlockHorizontal * 15,
                          child: RaisedButton(
                            onPressed: () {
                             //createRecord();
                             ajouter_panneau(titr.text, client.text,description.text, dropdownvalue, context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.transparent)),
                            color: bleu,
                            textColor: Colors.white,
                            child: Container(
                              height: SizeConfig.safeBlockVertical * 9,
                              width: double.infinity,
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.safeBlockHorizontal *
                                            22),
                                    child: Center(
                                      child: Text("Ajouter",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
