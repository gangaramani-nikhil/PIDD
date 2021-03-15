//import 'package:first_app/Authenticate/authenticate.dart';
import 'package:first_app/History.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        History("alo vera"),
        History("basil"),
        History("apple"),
        History("mango")
      ],
    );
  }
}
