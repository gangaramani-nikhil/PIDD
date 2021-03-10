import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class History extends StatefulWidget {
  final String plant;
  @override
  History(this.plant);
  _MyHistory createState() => _MyHistory();
}

class _MyHistory extends State<History> {
  Future<Map> data;
  Future<Map> fetchData() async {
    var response = await Dio().get(
        "https://trefle.io/api/v1/plants/search?token=MOl2QynCl9PEx3oLKn0tiQ9QRozWsCZHCDAmej3xuTg&q=" +
            widget.plant);
    return response.data;
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
            List imageValues = [];
            var val = snapshot.data;
            val = val["data"][0];
            for (var item in snapshot.data["data"]) {
              if (item["image_url"] != null) {
                imageValues.add(item["image_url"]);
              }
            }
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              color: Colors.green[200],
              margin: EdgeInsets.all(30),
              shadowColor: Colors.black,
              child: Container(
                  margin: EdgeInsets.all(0),
                  width: double.infinity,
                  height: 400,
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      width: 300,
                      height: 300,
                      child: FittedBox(
                        child: FadeInImage(
                            fadeInDuration: Duration(milliseconds: 100),
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                            image: NetworkImage(imageValues[0])),
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
                                val["common_name"],
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
                                val["scientific_name"],
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
                                val["year"].toString(),
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
                                "None",
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
