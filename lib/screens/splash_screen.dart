import 'package:flutter/material.dart';
import 'package:frontline/main.dart';
import 'package:frontline/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashView extends StatefulWidget{
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool isAutenticated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSessionStatus();
  }
  _getSessionStatus() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isAuthenticated")){
      setState(() {
        isAutenticated = prefs.getBool('isAuthenticated');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new SplashScreen(
          seconds: 2,
          navigateAfterSeconds: isAutenticated ? Home() : MyApp(),
          image: new Image.asset("./asset/front.jpg"),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.cyan
      ),
    );
  }
}