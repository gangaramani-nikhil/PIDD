import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/main.dart';
import 'package:first_app/wrapper.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  File _image;
  double _imageWidth;
  double _imageHeight;
  var _recognitions;

  selectFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        sendImage(_image);
      } else {
        print('No image selected ');
      }
    });
  }

  // select image from camera
  selectFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        sendImage(_image);
      } else {
        print('No image selected ');
      }
    });
  }

  // send image to predict method selected from gallery or camera
  sendImage(File image) async {
    if (image == null) return;
    await predict(image);

    // get the width and height of selected image
    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
            _image = image;
          });
        })));
  }

  @override
  void initState() {
    super.initState();

    loadModel().then((val) {
      setState(() {});
    });
  }

  loadModel() async {
    Tflite.close();
    try {
      String res;
      res = await Tflite.loadModel(
        model: "assets/newcnn.tflite",
        labels: "assets/labels.txt",
      );
      print(res);
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  // run prediction using TFLite on given image
  Future predict(File image) async {
    loadModel();
    var recognitions = await Tflite.runModelOnImage(
        path: image.path, // required
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );

    print(recognitions);

    CollectionReference data = FirebaseFirestore.instance.collection('data');
    final value = await data
        .where('mobile_number',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get();
    var plantsList = value.docs.first.data()["data"];
    var diseaseList = value.docs.first.data()["disease"];
    var plantName = recognitions[0]["label"].split("__")[0];
    plantName = plantName.replaceAll("__", " ");
    plantName = plantName.replaceAll("_", " ");
    var disease = recognitions[0]["label"].split("__")[1];
    disease = disease.replaceAll("__", " ");
    disease = disease.replaceAll("_", " ");
    plantsList.insert(0, plantName);
    diseaseList.insert(0, disease);
    await data
        .where('mobile_number',
            isEqualTo: FirebaseAuth.instance.currentUser.phoneNumber)
        .get()
        .then((value) => value.docs.forEach((element) {
              FirebaseFirestore.instance
                  .collection("data")
                  .doc(element.id)
                  .delete()
                  .then((value) => {});
            }));
    await data
        .add({
          'mobile_number': FirebaseAuth.instance.currentUser.phoneNumber,
          'data': plantsList,
          'disease': diseaseList
        })
        .then((value) => main())
        .catchError((w) => print(w));
    setState(() {
      _recognitions = recognitions[0]["label"];
      print(_recognitions.runtimeType);
    });
  }

  Future<Map> fetchData(plantName) async {
    var response = await Dio().get(
        "https://trefle.io/api/v1/plants/search?token=MOl2QynCl9PEx3oLKn0tiQ9QRozWsCZHCDAmej3xuTg&q=" +
            plantName);
    return response.data;
  }

  Widget printValue(rcg, context) {
    // if (rcg == null) {
    //   return Text('',
    //       style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700));
    // } else if (rcg.isEmpty) {
    //   return Center(
    //     child: Text("Could not recognize",
    //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
    //   );
    // }
    // return Padding(
    //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //   child: Center(
    //     child: Text(
    //       "Prediction: " + _recognitions[0]['label'].toString().toUpperCase(),
    //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    //     ),
    //   ),
    // );

    var plantName = rcg.split("__")[0];
    plantName = plantName.replaceAll("__", " ");
    plantName = plantName.replaceAll("_", " ");
    var disease = rcg.split("__")[1];
    disease = disease.replaceAll("__", " ");
    disease = disease.replaceAll("_", " ");
    return FutureBuilder(
        future: fetchData(plantName),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            var val = snapshot.data["data"][0];
            print(val);
            return AlertDialog(
              title: const Text('Prediction'),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                      child: Image.file(_image,
                          fit: BoxFit.fill, width: 200, height: 200)),
                  Divider(thickness: 1, color: Colors.black),
                  Text("Plant Predicted : " + plantName),
                  Text("Disease Detected : " + disease),
                  Text("Scientific Name : " + val["scientific_name"]),
                  Text("Common Name : " + val["common_name"]),
                  Text("Family : " + val["family"]),
                  Text("Genus : " + val["genus"]),
                  Text("Year : " + val["year"].toString()),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                  },
                  textColor: Theme.of(context).primaryColor,
                  child: const Text('Close'),
                ),
              ],
            );
          } else {
            return Center(child: Text("We are Processing your result"));
          }
        });
  }

  // gets called every time the widget need to re-render or build
  @override
  Widget build(BuildContext context) {
    // get the width and height of current screen the app is running on
    Size size = MediaQuery.of(context).size;

    // initialize two variables that will represent final width and height of the segmentation
    // and image preview on screen
    double finalW;
    double finalH;

    // when the app is first launch usually image width and height will be null
    // therefore for default value screen width and height is given
    if (_imageWidth == null && _imageHeight == null) {
      finalW = size.width;
      finalH = size.height;
    } else {
      // ratio width and ratio height will given ratio to
//      // scale up or down the preview image
      double ratioW = size.width / _imageWidth;
      double ratioH = size.height / _imageHeight;

      // final width and height after the ratio scaling is applied
      finalW = _imageWidth * ratioW * .85;
      finalH = _imageHeight * ratioH * .50;
    }

//    List<Widget> stackChildren = [];

    return Scaffold(
        body: _recognitions == null
            ? ListView(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Container(
                          height: 50,
                          width: 150,
                          color: Colors.redAccent,
                          child: FlatButton.icon(
                            onPressed: selectFromCamera,
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 30,
                            ),
                            color: Colors.deepPurple,
                            label: Text(
                              "Camera",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        color: Colors.tealAccent,
                        child: FlatButton.icon(
                          onPressed: selectFromGallery,
                          icon: Icon(
                            Icons.file_upload,
                            color: Colors.white,
                            size: 30,
                          ),
                          color: Colors.blueAccent,
                          label: Text(
                            "Gallery",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      ),
                    ],
                  ),
                ],
              )
            : printValue(_recognitions, context));
  }
}
