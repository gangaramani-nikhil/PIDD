import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return (Container(
      width: double.infinity,
      margin: EdgeInsets.all(15),
      alignment: Alignment(0.0, 0.0),
      child: Text(
        questionText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[800],
        ),
      ),
    ));
  }
}
