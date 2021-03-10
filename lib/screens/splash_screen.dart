import 'package:flutter/material.dart';
import 'package:frontline/main.dart';
import 'package:frontline/screens/auth.dart';
import 'package:frontline/screens/home.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new SplashScreen(
          seconds: 5,
          navigateAfterSeconds: MyApp(),
          title: new Text('Front line',
            style: new TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15.0,
            ),),
          image: new Image.asset("./asset/med.jpg"),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.cyan
      ),
    );
  }

}