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
    return Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(30),
                    child: Image.asset(
                      'assets/images/user.png',
                      height: 50,
                      width: 50,
                    )),
                Text(
                  FirebaseAuth.instance.currentUser.phoneNumber,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            FlatButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 40,
              minWidth: 40,
              disabledColor: Colors.grey,
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => MyApp()));
              },
              color: Colors.green[100],
              icon: Icon(Icons.logout),
              label: Text("Log Out"),
            )
          ],
        ));
  }
}
