import 'package:first_app/quiz.dart';
import 'package:first_app/result.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  int _totalScore = 0;
  var _questions;
  @override
  Widget build(BuildContext context) {
    _questions = [
      {
        'questionText': "What's your favorite color ?",
        'answers': [
          {'text': 'red', 'score': 10},
          {'text': 'yellow', 'score': 7},
          {'text': 'green', 'score': 5},
          {'text': 'blue', 'score': 1}
        ]
      },
      {
        'questionText': "What's your favorite animal ?",
        'answers': [
          {'text': 'Dog', 'score': 4},
          {'text': 'Cat', 'score': 7},
          {'text': 'Snake', 'score': 9},
          {'text': 'Lion', 'score': 10}
        ]
      },
      {
        'questionText': "Who are your favorite instructor?",
        'answers': [
          {'text': 'Max', 'score': 1}
        ]
      }
    ];
    return MaterialApp(
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
        body: _questionIndex < _questions.length
            ? Quiz(_questions, _answerQuestion, _questionIndex)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _totalScore = 0;
      _questionIndex = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore = _totalScore + score;
    setState(() => {_questionIndex = _questionIndex + 1});
  }
}
