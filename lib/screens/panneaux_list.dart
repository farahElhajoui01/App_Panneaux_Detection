import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/screens/Panneauencarte.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter/src/widgets/basic.dart' as row;
import 'package:login_dash_animation/widgets/headerWidget.dart';
import 'package:login_dash_animation/widgets/searchWidget.dart';
import 'package:firebase_database/firebase_database.dart';

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

  final dbRef = FirebaseDatabase.instance.reference().child("Panneau");
  List<dynamic> lists;
  @override
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
   
    return Scaffold(

        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: SizeConfig.safeBlockHorizontal * 4,
                color: Colors.white,
              ),
              HeaderWidget(),

              Flexible(
      child:StreamBuilder(
                  stream:
                  dbRef.onValue,
                  builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.snapshot.value != null) {
                        Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                        List<dynamic> list = map.values.toList();

                        return ListView.builder(
                          itemCount: list.length,
                          padding: EdgeInsets.all(2.0),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
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

                              child: Text(list[index]["titre"], style: TextStyle(
                                color: bleu,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,


                              )),

                            ),
                            SizedBox(height: SizeConfig.safeBlockHorizontal *2),
                            Container(

                            child: Text(list[index]["Description"], style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,


                            )),

                            ),
                            SizedBox(height: SizeConfig.safeBlockHorizontal * 1),
                            Container(

                            child: Text(list[index]["client_description"], style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            //fontWeight: FontWeight.bold,


                            ),
                            ),
                            ),
                            //SizedBox(width: SizeConfig.safeBlockHorizontal * 8),
                              ],
                              ),

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
                            child: Image.network(list[index]["image_url"],

                            fit: BoxFit.cover),

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
                            onPressed : () async{
                              await FlutterSession().set("titre",list[index]["titre"]);
                              await FlutterSession().set("lat",list[index]["lat"]);
                              await FlutterSession().set("lng",list[index]["lng"]);
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext ctx) => panneauencarte()));
                            }
                            ),


                            ),
                            ],
                            ),



                          ],

                            ),
                            );
                          },
                        );
                      } else {
                        return Container(
                            child: Center(
                                child: Text(
                                  'Es wurden noch keine Fotos im Chat gepostet.',
                                  style: TextStyle(fontSize: 20.0, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                )));
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
     ),
            ],
          ),
        ));


  }
}
