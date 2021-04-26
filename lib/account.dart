// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 300,
      height: 300,
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/user.png',
              height: 100,
              width: 100,
            ),
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            Text(
              FirebaseAuth.instance.currentUser.phoneNumber,
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
            FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 40,
                disabledColor: Colors.grey,
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                color: Colors.green[100],
                child: Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
