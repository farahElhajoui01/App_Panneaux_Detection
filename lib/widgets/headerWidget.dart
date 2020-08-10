import 'package:flutter/material.dart';
import 'package:login_dash_animation/SizeConfig.dart';
import 'package:login_dash_animation/screens/ajouter_panneau.dart';
import 'package:login_dash_animation/screens/carte_generale.dart';
import 'package:login_dash_animation/screens/panneaux_list.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

//const bleu2 = const Color(0xFFF1A5276);
const bleu2 = const Color(0xFFF1f94aa);


class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 5)
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: SizeConfig.safeBlockHorizontal * 20),
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Ajouter_panneau()),
              );
            },
            child: Icon(
              Icons.library_add,
              size: 28,
              color: bleu2,
            ),
          ),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 12),
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => panneauxList()),
              );
            },
            child: Icon(
              Icons.format_list_numbered_rtl,
              size: 28,
              color: bleu2,
            ),
          ),
          SizedBox(width: SizeConfig.safeBlockHorizontal * 12),
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => carte_generale()),
              );
            },
            child: Icon(
              Icons.map,
              size: 28,
              color: bleu2,
            ),
          ),
        ],
      ),
    );
  }

  Widget profile() {
    return Row(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text("Alessa Quizon",
                style: TextStyle(
                    color: Color(0xFFF2c4e5e), fontWeight: FontWeight.bold)),
            Text("Hawaii", style: TextStyle(color: Color(0xFFF1f94aa))),
          ],
        ),
        SizedBox(width: 5),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/images/user_5.jpg"),
                  fit: BoxFit.cover)),
        )
      ],
    );
  }
}
