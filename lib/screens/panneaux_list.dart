import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/screens/Panneauencarte.dart';
import 'package:flutter_session/flutter_session.dart';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/src/widgets/basic.dart' as row;
import 'package:flutter_session/flutter_session.dart';
import 'package:login_dash_animation/widgets/headerWidget.dart';
import 'package:login_dash_animation/widgets/searchWidget.dart';

class panneauxList extends StatefulWidget {
  @override
  _panneauxListState createState() => _panneauxListState();
}

//const bleu = const Color(0xFFF21618C);
const bleu2 = const Color(0xFFF1A5276);
const bleu = const Color(0xFFF1f94aa);


class _panneauxListState extends State<panneauxList> {
  @override
  void initState() {
    super.initState();
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


          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(


                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  HeaderWidget(),
                  SizedBox(height: SizeConfig.safeBlockHorizontal *5),
                  SearchWidget(),

                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 2,
                        vertical: SizeConfig.safeBlockHorizontal *2),

                    height: MediaQuery.of(context).size.height * 0.9,
                    width: MediaQuery.of(context).size.width,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 7),
                          Container(

                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 3,
                                vertical: SizeConfig.safeBlockHorizontal * 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height:SizeConfig.safeBlockHorizontal * 50 ,

                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 2,
                                vertical: SizeConfig.safeBlockHorizontal * 4),

                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        children: <Widget>[

                          Container(

                                  child: Text('Panneau de Pharmacie', style: TextStyle(
                                    color: bleu,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,


                                  )),

                          ),
                          SizedBox(height: SizeConfig.safeBlockHorizontal *2),
                          Container(

                                  child: Text('Guélliz avenue  elkhttabi', style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,


                                  )),

                          ),
                          SizedBox(height: SizeConfig.safeBlockHorizontal * 1),
                          Container(

                                  child: Text('Pharmacie elouidad', style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,


                                  ),
                                ),
                          ),


                        ],

                      ),
                      //SizedBox(width: SizeConfig.safeBlockHorizontal * 8),


                        Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                  topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                  bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                  bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                                ),

                              ),
                              width:SizeConfig.safeBlockHorizontal * 32,
                              height:SizeConfig.safeBlockHorizontal * 28,
                               child: Image.asset("assets/images/pa.jpg", fit: BoxFit.cover),

                            ),
                            SizedBox(height: SizeConfig.safeBlockHorizontal * 4),

                            Container(
                              width:SizeConfig.safeBlockHorizontal * 25 ,
                              height: SizeConfig.safeBlockHorizontal * 10,




                              child:RaisedButton(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(color: Color(0xFFF032f41),width: 0.3)),
                                  child: row.Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,

                                    children: <Widget>[
                                      SizedBox(width: SizeConfig.safeBlockHorizontal * 4),

                                      Center(
                                        child: Text('Voir', style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,


                                        )),
                                      ),

                                    ],
                                  ),
                                  onPressed : (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => panneauencarte()),
                                    );
                                  }
                              ),

                            ),
                          ],
                        ),

                    ],),



                      ),
                          Container(

                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 3,
                                vertical: SizeConfig.safeBlockHorizontal * 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height:SizeConfig.safeBlockHorizontal * 50 ,

                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 2,
                                vertical: SizeConfig.safeBlockHorizontal * 4),

                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[

                                    Container(

                                      child: Text('Panneau de Pharmacie', style: TextStyle(
                                        color: bleu,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,


                                      )),

                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal *2),
                                    Container(

                                      child: Text('Guélliz avenue  elkhttabi', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,


                                      )),

                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal * 1),
                                    Container(

                                      child: Text('Pharmacie elouidad', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,


                                      ),
                                      ),
                                    ),


                                  ],

                                ),
                                //SizedBox(width: SizeConfig.safeBlockHorizontal * 8),


                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                          topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                          bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                          bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                                        ),

                                      ),
                                      width:SizeConfig.safeBlockHorizontal * 32,
                                      height:SizeConfig.safeBlockHorizontal * 28,
                                      child: Image.asset("assets/images/pa.jpg", fit: BoxFit.cover),

                                      // child: Image.asset('assets/images/pa.jpg')
                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal * 4),

                                    Container(
                                      width:SizeConfig.safeBlockHorizontal * 25 ,
                                      height: SizeConfig.safeBlockHorizontal * 10,




                                      child:RaisedButton(
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(color: Color(0xFFF032f41),width: 0.3)),
                                          child: row.Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: <Widget>[
                                              SizedBox(width: SizeConfig.safeBlockHorizontal * 4),

                                              Center(
                                                child: Text('Voir', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,


                                                )),
                                              ),

                                            ],
                                          ),
                                          onPressed : (){
                                          }
                                      ),

                                    ),
                                  ],
                                ),

                              ],),



                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),

                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 3,
                                vertical: SizeConfig.safeBlockHorizontal * 2),

                            height:SizeConfig.safeBlockHorizontal * 50 ,

                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.safeBlockHorizontal * 2,
                                vertical: SizeConfig.safeBlockHorizontal * 4),

                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[

                                    Container(

                                      child: Text('Panneau de Pharmacie', style: TextStyle(
                                        color: bleu,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,


                                      )),

                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal *2),
                                    Container(

                                      child: Text('Guélliz avenue  elkhttabi', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,


                                      )),

                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal * 1),
                                    Container(

                                      child: Text('Pharmacie elouidad', style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        //fontWeight: FontWeight.bold,


                                      ),
                                      ),
                                    ),


                                  ],

                                ),
                                //SizedBox(width: SizeConfig.safeBlockHorizontal * 8),


                                Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(SizeConfig.safeBlockHorizontal * 3),
                                          topRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                          bottomRight: Radius.circular( SizeConfig.safeBlockHorizontal * 3),
                                          bottomLeft: Radius.circular( SizeConfig.safeBlockHorizontal * 3),

                                        ),

                                      ),
                                      width:SizeConfig.safeBlockHorizontal * 32,
                                      height:SizeConfig.safeBlockHorizontal * 28,
                                      child: Image.asset("assets/images/pa.jpg", fit: BoxFit.cover),

                                      // child: Image.asset('assets/images/pa.jpg')
                                    ),
                                    SizedBox(height: SizeConfig.safeBlockHorizontal * 4),

                                    Container(
                                      width:SizeConfig.safeBlockHorizontal * 25 ,
                                      height: SizeConfig.safeBlockHorizontal * 10,






                                      child:RaisedButton(

                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              side: BorderSide(color: Color(0xFFF032f41),width: 0.3)),
                                          child: row.Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,

                                            children: <Widget>[
                                              SizedBox(width: SizeConfig.safeBlockHorizontal * 4),

                                              Center(
                                                child: Text('Voir', style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,


                                                )),
                                              ),

                                            ],
                                          ),
                                          onPressed : (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => panneauencarte()),
                                            );
                                          }
                                      ),

                                    ),
                                  ],
                                ),

                              ],),



                          ),

    ],),



          ),
        ],
      ),),),],),
    );
  }
}
