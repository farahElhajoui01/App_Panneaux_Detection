import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_dash_animation/components/customTextfield.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:mysql1/mysql1.dart' hide Row;
import 'package:flutter_session/flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:io'  ;
import 'package:async/async.dart';
import 'package:flutter/src/widgets/basic.dart' as row ;
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Img;
import 'dart:math' as Math;
import 'package:flutter_session/flutter_session.dart';
import 'package:dio/dio.dart' as dio;

import 'package:firebase_database/firebase_database.dart';
import 'package:login_dash_animation/widgets/headerWidget.dart';




class Ajouter_panneau extends StatefulWidget {

  @override
  _Ajouter_panneauState createState() => _Ajouter_panneauState();
}
final databaseReference = FirebaseDatabase.instance.reference();
const bleu =  Colors.black;
//const bleu = const Color(0xFFF21618C);

const bleu2 = const Color(0xFFF1f94aa);

void createRecord(){

  databaseReference.child("1").set({
    'title': 'Mastering EJB',
    'description': 'Programming Guide for J2EE'
  });
  databaseReference.child("2").set({
    'title': 'Flutter in Action',
    'description': 'Complete Programming Guide to learn Flutter'
  });
}


class _Ajouter_panneauState extends State<Ajouter_panneau> {


 var session = FlutterSession();
  File _image;
  String msg = '';
  final immatr = TextEditingController();
  final agrem = TextEditingController();
  final numtaxi = TextEditingController();
  var imageColor=Colors.white;
  var titre='Image';
  var textcolor= Colors.white;

  List<String> categories=new List();
  var dropdownvalue;



  @override
  void initState() {
    super.initState();

  }


 Future getImageCamera() async{
   var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

   final tempDir =await getTemporaryDirectory();
   final path = tempDir.path;

   int rand= new Math.Random().nextInt(100000);

   Img.Image image= Img.decodeImage(imageFile.readAsBytesSync());
   Img.Image smallerImg = Img.copyResize(image,height: 500);

   var compressImg= new File("$path/image_$rand.jpg")
     ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));


   setState(() {
     _image = compressImg;
   });
 }


  @override
  @override
  Widget build(BuildContext context) {
    // getMarques();
    //  getGategories();
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
                          horizontal: SizeConfig.safeBlockHorizontal * 5,
                          vertical: SizeConfig.safeBlockHorizontal *7),
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
                                      color:bleu,
                                      fontSize: 30,
                                      fontFamily: "Pacificio",

                                    )),
                              ),
                            ),

                            SizedBox(height: SizeConfig.safeBlockHorizontal * 7),


                            Container(
                              height: SizeConfig.safeBlockHorizontal * 15,
                              child: CustomTextField(
                                controller:immatr,

                                label: "Titre",
                                icon: Icon(
                                  Icons.title,
                                  size: 27,
                                  color: Color(0xFFF032f41),
                                ),

                              ),
                            ),
                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),



                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                            /*  RaisedButton(
                          child: Text("UPLOAD"),
                          onPressed:(){
                            upload(_image);
                          },
                        ),*/

                            Container(
                              height: SizeConfig.safeBlockHorizontal * 15,
                              child: CustomTextField(
                                  controller:agrem,

                                  label: "Client",
                                  icon: Icon(
                                    Icons.person_outline,
                                    size: 27,
                                    color: Color(0xFFF032f41),
                                  ),

                              ),
                            ),

                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                            Container(
                              height: SizeConfig.safeBlockHorizontal * 15,
                              child: CustomTextField(

                                  controller:numtaxi,
                                  label: "Adresse",
                                  isPassword: false,
                                  icon: Icon(
                                    Icons.add_location,
                                    size: 27,
                                    color: Color(0xFFF032f41),
                                  ),

                              ),

                            ),

                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),
                            Container(
                              child:Center(
                                child: Text(msg, style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,


                                )),
                              ),
                            ),

                            Row(
                              children: <Widget>[




                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),

                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(

                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular( 10),
                                      bottomRight: Radius.circular( 10),
                                      bottomLeft: Radius.circular( 10),

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

                                    child:DropdownButton<String>(
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
                                      icon: Icon(Icons.keyboard_arrow_down,color: Color(0xFFF032f41),
                                      ),
                                      iconSize: 27,
                                      elevation: 20,
                                      onChanged: (String newval){
                                        setState((){
                                          dropdownvalue = newval;

                                          print("select:"+dropdownvalue);

                                        });

                                      },
                                      items: ['a']
                                          .map<DropdownMenuItem<String>>((String value){
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
                                  width:SizeConfig.safeBlockHorizontal * 35 ,
                                  height: SizeConfig.safeBlockHorizontal * 15,




                                  child:RaisedButton(
                                      color: bleu2,
                                      padding: const EdgeInsets.only(right:0,left:15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          side: BorderSide(color: Color(0xFFF1f94aa),width: 0.3)),
                                      child: row.Row(

                                        children: <Widget>[

                                          Text(titre, style: TextStyle(
                                            color: textcolor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,


                                          )),
                                          SizedBox(width: SizeConfig.safeBlockHorizontal * 2),
                                          Icon(Icons.add_a_photo,size: 32,color:textcolor,),

                                        ],
                                      ),
                                      onPressed : (){
                                        getImageCamera();
                                      }
                                  ),

                                ),
                              ],
                            ),
                            SizedBox(height: SizeConfig.safeBlockHorizontal * 2),

                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),

                            Container(
                              height: SizeConfig.safeBlockHorizontal * 15,
                              child: RaisedButton(
                                onPressed: () {
                                  createRecord();

                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color:Colors.transparent)),
                                color: bleu,
                                textColor: Colors.white,

                                child: Container(
                                  height: SizeConfig.safeBlockVertical * 9,
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Container(


                                        padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal * 22),
                                        child:Center(
                                          child: Text("Ajouter", style: TextStyle(

                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,



                                          )),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),),
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
