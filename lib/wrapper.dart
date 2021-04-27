import 'package:first_app/Authenticate/authenticate_future.dart';
import 'package:first_app/History.dart';
import 'package:first_app/account.dart';
import 'package:first_app/homescreen.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wrapper extends StatefulWidget {
  final int _widgetGet;
  Wrapper(this._widgetGet);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future<Map> getData() async {
    CollectionReference data = FirebaseFirestore.instance.collection('data');
    final value = await data
        .where('mobile_number',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get();
    if (value.size == 0) {
      await data.add({
        'mobile_number': FirebaseAuth.instance.currentUser.phoneNumber,
        'data': ["Mango", "Tulsi"]
      }).then((value) => main());
    }
    return value.docs.first.data();
  }

  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.data != null && widget._widgetGet == 2) {
            List<Widget> widgetList = [];
            var count = 0;
            while (count != snapshot.data["data"].length) {
              widgetList.add(History(snapshot.data["data"][count],
                  snapshot.data["disease"][count], count == 0 ? true : false));
              count++;
            }
            if (widgetList.length != 0) {
              widgetList.add(Padding(padding: EdgeInsets.all(50)));
            }
            return widgetList.length != 0
                ? SingleChildScrollView(
                    child: Column(
                    children: widgetList,
                  ))
                : Center(
                    child: Text(
                        "Click on the camara icon to start predicting plants"));
          } else if (snapshot.data != null && widget._widgetGet == 1) {
            return HomeScreen();
          } else if (snapshot.data != null && widget._widgetGet == 0) {
            return Account();
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
