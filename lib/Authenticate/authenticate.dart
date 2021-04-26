// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class Authenticate extends StatefulWidget {
//   @override
//   _AuthenticateState createState() => _AuthenticateState();
// }

// class _AuthenticateState extends State<Authenticate> {
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;

//     // Create a new credential
//     final GoogleAuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );

//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: SingleChildScrollView(
//             child: Container(
//                 padding: EdgeInsets.all(20),
//                 margin: EdgeInsets.only(),
//                 height: 300,
//                 width: double.infinity,
//                 child: Card(
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20))),
//                   color: Colors.green[400],
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       FlatButton(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           height: 40,
//                           disabledColor: Colors.grey,
//                           onPressed: signInWithGoogle,
//                           color: Colors.white,
//                           child: Text(
//                             "Login/Register using Google",
//                             style: TextStyle(
//                               color: Colors.black,
//                             ),
//                           )),
//                     ],
//                   ),
//                 ))));
//   }
// }
