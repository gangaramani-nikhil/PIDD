// import 'package:first_app/Authenticate/authenticate.dart';
import 'package:first_app/Authenticate/authenticate_future.dart';
// import 'package:first_app/Authenticate/authenticate_future.dart';
import 'package:first_app/History.dart';
import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return History("Mango");
      
    } else {
      return AuthenticateFuture();
    }
  }
}
