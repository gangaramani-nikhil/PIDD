import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticateFuture extends StatefulWidget {
  @override
  _AuthenticateFutureState createState() => _AuthenticateFutureState();
}

class _AuthenticateFutureState extends State<AuthenticateFuture> {
  var buttonEnable = false;
  final mobileNumberController = TextEditingController();
  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  // ignore: missing_return
  Future<bool> loginUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 120),
        phoneNumber: mobileNumberController.text,
        verificationCompleted: (AuthCredential cred) async {
          // ignore: unused_local_variable
          UserCredential result = await _auth.signInWithCredential(cred);
        },
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null);
  }

  void checkLength(data) {
    if (data.length == 10) {
      setState(() {
        buttonEnable = true;
      });
    } else {
      setState(() {
        buttonEnable = false;
      });
    }
  }

  void buttonPress() {}

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(),
                height: 300,
                width: double.infinity,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Colors.green[400],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Login/Register",
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                      Container(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            onChanged: checkLength,
                            controller: mobileNumberController,
                            maxLength: 10,
                            maxLengthEnforced: true,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: "Enter Your 10 digit Mobile Number",
                                isDense: true),
                            keyboardType: TextInputType.phone,
                          )),
                      FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 40,
                          disabledColor: Colors.grey,
                          onPressed: buttonEnable ? loginUser : null,
                          color: Colors.white,
                          child: Text(
                            "Login/Register",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ))
                    ],
                  ),
                ))));
  }
}
