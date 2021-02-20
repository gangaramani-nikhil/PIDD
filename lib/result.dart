import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;
  Result(this.totalScore, this.resetQuiz);
  String get resultPhrase {
    var resultText = 'You did it!';
    if (totalScore <= 8) {
      resultText = 'You are awesome';
    } else {
      resultText = 'Hello there wierdo';
    }
    return resultText;
  }

  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(resultPhrase,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            RaisedButton(child: Text("Try Again !"), onPressed: resetQuiz)
          ]),
        ));
  }
}
