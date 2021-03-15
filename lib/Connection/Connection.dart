import 'package:flutter/material.dart';

class Connection extends StatelessWidget {
  final Function check;
  Connection(this.check);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "No Connection",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
        ),
        FlatButton(
            onPressed: check,
            color: Colors.grey[300],
            child: Text("Try Again",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black)))
      ],
    )));
  }
}
