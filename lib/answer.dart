import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answer;
  final Function fn;
  final int score;
  Answer(this.answer, this.fn, this.score);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        color: Colors.green[100],
        textColor: Colors.black,
        onPressed: () => {fn(score)},
        child: Text(answer),
      ),
    );
  }
}
