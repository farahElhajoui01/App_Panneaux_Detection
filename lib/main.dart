import 'package:flutter/material.dart';
import 'package:login_dash_animation/screens/Panneauencarte.dart';
import 'package:login_dash_animation/screens/SplashScreen.dart';





void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      routes: {
        '/panneauencarte': (ctx) => panneauencarte(),
      },
      debugShowCheckedModeBanner: false,
      title: 'DP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:SplashScreen(),


    );
  }
}
