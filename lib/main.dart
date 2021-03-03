import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './History.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  Future<bool> internetConnection;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void initState() {
    setState(() {
      internetConnection = isConnected();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/PIDD-logos_transparent.png',
            height: 100,
            width: 100,
          ),
          shadowColor: Colors.green[300],
          toolbarHeight: 100,
          elevation: 10,
          backgroundColor: Colors.green[400],
          bottomOpacity: 1.0,
          centerTitle: true,
        ),
        body: FutureBuilder<bool>(
            future: internetConnection,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data) {
                return FutureBuilder(
                    future: _initialization,
                    builder: (BuildContext context,
                        AsyncSnapshot<FirebaseApp> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          child: Column(children: [
                            History(),
                            History(),
                            History(),
                            History(),
                            History(),
                            History(),
                          ]),
                        );
                      } else {
                        return Text("Our servers are freaking out");
                      }
                    });
              } else {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Connection",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red),
                    ),
                    FlatButton(
                        onPressed: initState,
                        color: Colors.grey[300],
                        child: Text("Try Again",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black)))
                  ],
                ));
              }
            }),
      ),
    );
  }
}
