import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontline/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => new _AuthState();
}

class _AuthState extends State<Auth> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();

  bool _readOnly = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _autoFill.hint.then((value){
      setState(() {
        _phoneController.text = value;
      });
    });

  }

  _loginWithOTP(BuildContext context) async{
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      _storeSession(_phoneController.text);
      Fluttertoast.showToast(
          msg: "Phone number automatically verified. Signed in successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.cyan,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()));
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
          print( '${authException.message}');
          Fluttertoast.showToast(
              msg: "Phone number verification failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.cyan,
              textColor: Colors.white,
              fontSize: 16.0
          );
    };
    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      Fluttertoast.showToast(
          msg: "Please check your phone for the verification code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.cyan,
          textColor: Colors.white,
          fontSize: 16.0
      );
      showOTPAlertDialog(context);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneController.text,
          timeout: const Duration(seconds: 10),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.cyan,
          textColor: Colors.white,
          fontSize: 16.0
      );
      throw Exception("Failed");
    }
  }


  Future<User> signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      return (await _auth.signInWithCredential(credential)).user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to sign in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.cyan,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print("login failed");
    }
  }

  showOTPAlertDialog(BuildContext context) {

    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        print("continue");
        Navigator.of(context, rootNavigator: true).pop();
        FocusScope.of(context).unfocus();
        signInWithPhoneNumber().then((User user){
          print(user.uid);
          setState(() {
            _smsController.text = "";
          });
          _storeSession(_phoneController.text);
          Fluttertoast.showToast(
              msg: "Successfully signed in",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.cyan,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home()));
        });
      },
    );

    // set up the OTPAlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP"),
      content:  TextField(
        decoration: InputDecoration(
            hintText: "Enter OTP",
            hintStyle: TextStyle(
                color: Colors.grey, fontSize: 12.0),
        ),
        controller: _smsController,
        readOnly: _readOnly,
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _storeSession(String phoneNumber) async{
    if(phoneNumber.isNotEmpty){
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isAuthenticated", true);
      prefs.setString("phoneNumber", phoneNumber);
      if(prefs.containsKey("isAuthenticated")){
        print(prefs.getBool('isAuthenticated'));
      }
      if(prefs.containsKey("phoneNumber")){
        print(prefs.getString('phoneNumber'));
      }
    }
  }

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil.getInstance().setWidth(120),
      height: 1.0,
      color: Colors.black26.withOpacity(.2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    return new Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Image.asset("./asset/front.jpg"),
              ),
              Expanded(
                child: Container(),
              ),
              Image.asset("./asset/footer_top_bg.png")
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 80.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(300),
                  ),
//                  FormCard(),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil.getInstance().setHeight(400),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, 15.0),
                              blurRadius: 15.0),
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0.0, -10.0),
                              blurRadius: 10.0),
                        ]),
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("User Login",
                              style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(33),
                                  fontFamily: "Poppins-Bold",
                                  letterSpacing: .6)),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          Text("Phone Number",
                              style: TextStyle(
                                  fontFamily: "Poppins-Medium",
                                  fontSize:
                                  ScreenUtil.getInstance().setSp(26))),
                          TextField(
                            decoration: InputDecoration(
//                                prefixIcon: Icon(Icons.email),
                                hintText: "Enter Phone Number",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.phonelink_setup),
                                onPressed: () async => {
                                  FocusScope.of(context).unfocus(),
                                  _phoneController.text = await _autoFill.hint
                                },
                              )
                            ),
                            controller: _phoneController,
                            readOnly: _readOnly,
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(30),
                          ),
                          SizedBox(
                            height: ScreenUtil.getInstance().setHeight(35),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                      ),
                      FloatingActionButton(
                        child: Icon(Icons.exit_to_app,color: Colors.black,),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          print("login");
                          _loginWithOTP(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      horizontalLine(),
                      Text("",
                          style: TextStyle(
                              fontSize: 16.0, fontFamily: "Poppins-Medium")),
                      horizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }
}
