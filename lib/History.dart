import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class History extends StatefulWidget {
  final String plant;
  final String disease;
  final bool latest;
  @override
  History(this.plant, this.disease, this.latest);
  _MyHistory createState() => _MyHistory();
}

class _MyHistory extends State<History> {
  Future<Map> data;
  Future<Map> fetchData() async {
    // var response = await Dio().get(
    //     "https://trefle.io/api/v1/plants/search?token=MOl2QynCl9PEx3oLKn0tiQ9QRozWsCZHCDAmej3xuTg&q=" +
    //         widget.plant);
    // return response.data;
    CollectionReference data = FirebaseFirestore.instance.collection('plant_info');
    final value = await data
        .where('common_name',
        isEqualTo: widget.plant)
        .get();
    return value.docs.first.data();
  }

  void initState() {
    data = fetchData();
    super.initState();
  }

  Widget build(BuildContext context) {
    double _fontsize = 15;
    return FutureBuilder<Map>(
        future: data,
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Card(
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              // color: Colors.green[200],
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 5, top: 15, left: 30, right: 30),
              shadowColor: Colors.black,
              child: Container(
                  margin: EdgeInsets.all(0),
                  width: double.infinity,
                  height: widget.latest ? 350 : 300,
                  child: Column(children: <Widget>[
                    widget.latest
                        ? Container(
                            padding: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            child: Text(
                              "Latest Prediction",
                              style: TextStyle(
                                  fontSize: 20,
                                  shadows: [
                                    Shadow(blurRadius: 1, color: Colors.black)
                                  ],
                                  fontStyle: FontStyle.values[1],
                                  color: Colors.green[900]),
                            ))
                        : Container(),
                    Container(
                      padding: EdgeInsets.only(top: widget.latest ? 5 : 20),
                      width: 300,
                      height: 200,
                      child: FittedBox(
                        child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 100),
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                            image: NetworkImage(snapshot.data["image_url"])),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(children: [
                              Text(
                                "Common Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontsize,
                                ),
                              ),
                              Text(" : "),
                              Text(
                                snapshot.data["common_name"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: _fontsize,
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Text(
                                "Scientific Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontsize,
                                ),
                              ),
                              Text(" : "),
                              Text(
                                snapshot.data["scientific_name"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: _fontsize,
                                ),
                              )
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Text(
                                "Discovered (year)",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontsize,
                                ),
                              ),
                              Text(" : "),
                              Text(
                                snapshot.data["discovery"],
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: _fontsize,
                                ),
                              )
                            ]),
                          ),
                          Container(
                            child: Row(children: [
                              Text(
                                "Disease Detected",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: _fontsize,
                                ),
                              ),
                              Text(" : "),
                              Text(
                                widget.disease,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: _fontsize,
                                ),
                              )
                            ]),
                          ),
                        ],
                      ),
                    )
                  ])),
              elevation: 30,
            );
          } else {
            return Center(
              child: SpinKitRing(
                duration: Duration(milliseconds: 500),
                color: Colors.green[400],
                size: 100.0,
              ),
            );
          }
        });
  }
}

// FadeInImage.assetNetwork(
//                                   placeholder: SpinKitCircle(color: green[400],size:100),
//                                   image: NetworkImage(val["data"][0]["image_url"]),
//                           )

// decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                           image: NetworkImage(val["data"][0]["image_url"]),
//                       fit: BoxFit.fill),
//                         ),
