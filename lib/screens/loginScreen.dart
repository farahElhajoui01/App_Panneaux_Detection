import 'package:flutter/material.dart';
import 'package:login_dash_animation/components/buttonLoginAnimation.dart';
import 'package:login_dash_animation/components/customTextfield.dart';
import 'package:login_dash_animation/models/mysql.dart';
import 'package:login_dash_animation/screens/Menu.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/screens/ajouterVehicule.dart';
import 'package:mysql1/mysql1.dart' hide Row;
import 'package:password/password.dart';
import 'package:flutter_session/flutter_session.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String msg = '';
  var session = FlutterSession();

  final login = TextEditingController();
  final password = TextEditingController();


  Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2', port: 3306, user: 'root', db: 'taxiapp'));
    return conn;
  }

  _login() async {
    print("heey1");

    String login = "farah";
    String passw = "eee";
    getConnection().then((conn) async {
      var id;
      var nom='';
      var password = '';
      var results = await conn.query(
          'select login, password,id,nom from chauffeurs where login = ?', [login]);

      if (results.isEmpty) {
        setState(() {
          msg = "Authetificateur erroné";
        });
      } else {
        for (var row in results) {
          password = row[1];
          id=row[2];
          nom=row[3];
        }

        if (password == passw) {
          await session.set("id", id);
          await session.set("nom", nom);
          setState(() {
            msg = "great";
          });
          //Navigator.pushReplacementNamed(context, '/ajouterVéhicule');
        } else {
          setState(() {
            msg = "Mot de passe erroné";
          });
        }
      }
    });
    print("heey" + msg);
  }

  _test() {
    print("im the testing function");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset("assets/images/bg2.jpg", fit: BoxFit.cover),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xFFF001117).withOpacity(0.8),
          ),
          Column(
            children: <Widget>[],
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: SizeConfig.safeBlockVertical * 5),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.safeBlockHorizontal * 5,
                        vertical: SizeConfig.safeBlockVertical * 5),
                    margin: EdgeInsets.only(
                        left: SizeConfig.safeBlockHorizontal * 6,
                        right: SizeConfig.safeBlockHorizontal * 6,
                        bottom: SizeConfig.safeBlockVertical * 8,
                        top: SizeConfig.safeBlockVertical * 10),
                    height: MediaQuery.of(context).size.height * 0.70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          topRight: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          bottomLeft: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                          bottomRight: Radius.circular(
                              SizeConfig.safeBlockHorizontal * 7),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.safeBlockHorizontal * 5,
                              right: SizeConfig.safeBlockHorizontal * 5,
                              top: SizeConfig.safeBlockVertical * 0),
                          child: Text("Authentifier-vous ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFF032f41),
                                fontSize: 30,
                                fontFamily: "Pacificio",
                              )),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 5),
                        Container(
                          height: SizeConfig.safeBlockVertical * 10,
                          child: CustomTextField(
                            controller:login,
                            label: "Login",
                            icon: Icon(
                              Icons.mail,
                              size: 27,
                              color: Color(0xFFF032f41),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 4),
                        Container(
                          height: SizeConfig.safeBlockVertical * 10,
                          child: CustomTextField(
                            controller:password,


                            label: "Mot de passe",
                            isPassword: true,
                            icon: Icon(
                              Icons.https,
                              size: 27,
                              color: Color(0xFFF032f41),
                            ),
                          ),
                        ),
                        Container(
                          child:Center(
                            child: Text(msg, style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              //fontWeight: FontWeight.bold,


                            )),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 2),
                        RaisedButton(
                          onPressed: () {
                            print("heey1");
                            var id;
                            var nom='';

                            getConnection().then((conn) async {
                              var passw = '';
                              if( login.text==''|| password.text=='') {
                                setState(() {
                                  msg ="Saisissez le login et le mot de passe s'il vous plait!";
                                });

                              }
                              else{
                              var results = await conn.query('select login, password,id,nom from chauffeurs where login = ?',
                                  [login.text]);
                             /// final algorithm = PBKDF2();
                            //  final hash = Password.hash(password, algorithm);



                              if (results.isEmpty) {
                                setState(() {
                                  msg = "Authetificateur erroné";
                                });
                              } else {
                                for (var row in results) {
                                  passw = row[1];
                                  id = row[2];

                                  nom = row[3];

                                }
                                //print(Password.verify(password.text, passw));

                               // if (Password.verify(password.text, passw));
                                 if (password.text==passw) {
                                   //print("infos" +id+"/"+nom);
                                   await session.set("id", id.toString());
                                   await session.set("nom", nom);

                                  setState(() {
                                    msg = "";
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AjouterVehicule()),
                                    );
                                  });
                                  //Navigator.pushReplacementNamed(context, '/ajouterVéhicule');
                                } else {
                                  setState(() {
                                    msg = "Mot de passe erroné";
                                  });
                                }
                              }}
                            });
                            print("heey" + msg);

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              side: BorderSide(color: Colors.white)),
                          color: Color(0xffe6b301),
                          textColor: Colors.white,

                          child: Container(
                            height: SizeConfig.safeBlockVertical * 9,
                            width: double.infinity,
                            child: Row(
                            children: <Widget>[
                              Container(

                                margin: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 10),

                                padding: EdgeInsets.only(left:SizeConfig.safeBlockHorizontal * 3,right: SizeConfig.safeBlockHorizontal * 7),
                                child: Text("se connecter", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,


                                )),
                              ),
                              SizedBox(width: 0),
                              Container(
                                //width: 50.0,
                                //height: 50.0,
                                  margin: EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 5),
                                  padding: const EdgeInsets.all(2.0),//I used some padding without fixed width and height
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,// You can use like this way or like the below line
                                    //borderRadius: new BorderRadius.circular(30.0),
                                    color: Colors.white,
                                  ),
                                  child:Icon(Icons.arrow_forward, color: Color(0xffe6b301),size: 28)
                              ),//............

                            ],
                        ),
                          ),),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
