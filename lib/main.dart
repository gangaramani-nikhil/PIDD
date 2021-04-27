// import 'dart:html';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/Connection/Connection.dart';
// import 'package:first_app/homescreen.dart';
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
  bool floatbuttonenable = false;
  List _color = [
    Colors.white.withOpacity(.50),
    Colors.white.withOpacity(.50),
    Colors.white
  ];
  int index = 2;

  isfloatbuttonenable() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

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
      floatbuttonenable = isfloatbuttonenable();
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
    isfloatbuttonenable();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) => Scaffold(
            extendBody: true,

            bottomNavigationBar: Visibility(
                visible: floatbuttonenable,
                // visible: true,
                child: BottomAppBar(
                  child: Container(
                    color: Colors.green[400],
                    height: 70,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.account_box_rounded,
                                color: _color[0],
                              ),
                              onPressed: () {
                                setState(() {
                                  index = 0;
                                  _color[0] = Colors.white;
                                  _color[1] = Colors.white.withOpacity(.50);
                                  _color[2] = Colors.white.withOpacity(.50);
                                });
                              },
                            ),
                            Text(
                              "Account",
                              style: TextStyle(color: _color[0]),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: _color[1],
                              ),
                              onPressed: () {
                                setState(() {
                                  index = 1;
                                  _color[0] = Colors.white.withOpacity(.50);
                                  _color[1] = Colors.white;
                                  _color[2] = Colors.white.withOpacity(.50);
                                });
                              },
                            ),
                            Text(
                              "Predict",
                              style: TextStyle(color: _color[1]),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.history_outlined,
                                color: _color[2],
                              ),
                              onPressed: () {
                                setState(() {
                                  index = 2;
                                  _color[0] = Colors.white.withOpacity(.50);
                                  _color[1] = Colors.white.withOpacity(.50);
                                  _color[2] = Colors.white;
                                });
                              },
                            ),
                            Text(
                              "History",
                              style: TextStyle(color: _color[2]),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )),
            // floatingActionButton: Visibility(
            //     visible: _floatbuttonenable,
            //     child: FloatingActionButton(
            //         backgroundColor: Colors.green[900],
            //         child: Icon(Icons.camera_alt),
            //         onPressed: () {
            //           Navigator.push(context,
            //               MaterialPageRoute(builder: (context) {
            //             return HomeScreen();
            //           }));
            //         })),
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
                    // return Wrapper();
                    // return Wrapper(_index);
                    return Wrapper(index);
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
        ));
  }
}
