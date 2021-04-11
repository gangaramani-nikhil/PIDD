import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import '../History.dart';

class AuthenticateFuture extends StatefulWidget {
  final String code;
  @override
  AuthenticateFuture(this.code);
  @override
  _AuthenticateFutureState createState() => _AuthenticateFutureState();
}

class _AuthenticateFutureState extends State<AuthenticateFuture> {
  var buttonEnable = false;
  final mobileNumberController = TextEditingController();
  final pincontroller = TextEditingController();

  void dispose() {
    mobileNumberController.dispose();
    super.dispose();
  }

  Future registerUser(String mobile, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    mobile = widget.code + mobile;
    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          Navigator.of(context).pop();
          final UserCredential user =
              await _auth.signInWithCredential(credential);
          if (user != null) {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             SingleChildScrollView(child: MyApp())));
            main();
          } else {
            print("Error");
          }
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter Code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [TextField(controller: pincontroller)],
                  ),
                  actions: [
                    FlatButton(
                      onPressed: () async {
                        final code = pincontroller.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);
                        UserCredential user =
                            await _auth.signInWithCredential(credential);
                        if (user != null) {
                          Navigator.of(context).pop();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             SingleChildScrollView()));
                          final dbVal = await FirebaseFirestore.instance
                              .collection('data')
                              .where('mobile_number',
                                  isEqualTo: FirebaseAuth
                                      .instance.currentUser.phoneNumber)
                              .get();
                          print(dbVal.size);
                          if (dbVal.size == 0) {
                            FirebaseFirestore.instance.collection('data').add({
                              'mobile_number':
                                  FirebaseAuth.instance.currentUser.phoneNumber,
                              'data': ["Mango", "Tulsi"]
                            });
                          }

                          main();
                        } else {
                          print("Error");
                        }
                      },
                      child: Text("Verify"),
                      color: Colors.white,
                      textColor: Colors.black,
                    )
                  ],
                );
              });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception);
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  // ignore: missing_return
  Future<bool> loginUser() async {}

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
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
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
                          onPressed: buttonEnable
                              ? () => {
                                    registerUser(
                                        mobileNumberController.text, context)
                                  }
                              : null,
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
