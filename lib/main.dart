import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Connection/Connection.dart';
import 'package:first_app/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  Future<bool> _internetConnection;
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
    return Future.value(false);
  }

  void check() {
    setState(() {
      _internetConnection = isConnected();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    check();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
            future: _internetConnection,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return Wrapper();
              } else if (snapshot.data == null) {
                return Center(
                  child: SpinKitRing(
                    duration: Duration(milliseconds: 500),
                    color: Colors.green[400],
                    size: 100.0,
                  ),
                );
              } else {
                return Connection(check);
              }
            }),
      ),
    );
  }
}
