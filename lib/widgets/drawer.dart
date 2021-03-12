import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontline/screens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String phoneNumber = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPhoneByPref();
  }

  _getPhoneByPref() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("phoneNumber")){
      setState(() {
        phoneNumber = prefs.getString('phoneNumber');
      });
    }
  }

  _logoutAction() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("isAuthenticated") && prefs.containsKey("phoneNumber")){
      bool isLoggedin = prefs.getBool("isAuthenticated");
      if(isLoggedin){
        prefs.remove("isAuthenticated");
        prefs.remove("phoneNumber");
        Fluttertoast.showToast(
            msg: "Successfully logged out",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.cyan,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Auth()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('asset/front.jpg'))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2.0),
            child: Text("Signed in as " + phoneNumber,
              style: TextStyle(
                fontSize: 10.0,
                fontStyle: FontStyle.italic
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              _logoutAction()
            },
          ),
        ],
      ),
    );
  }
}