import 'package:first_app/Authenticate/authenticate_future.dart';
import 'package:first_app/History.dart';
// import 'package:first_app/History.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<List> getData() async {
    CollectionReference data = FirebaseFirestore.instance.collection('data');
    final value = await data
        .where('mobile_number',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get();
    return value.docs.first.data()["data"];
  }

  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<Widget> widgetList = [];
            for (String val in snapshot.data) {
              widgetList.add(History(val));
            }
            return SingleChildScrollView(
                child: Column(
              children: widgetList,
            ));
          } else {
            return Container(
                alignment: Alignment.center,
                child: Center(
                  child: SpinKitFadingFour(color: Colors.green),
                ));
          }
        },
      );
    } else {
      return AuthenticateFuture("+91");
    }
  }
}
