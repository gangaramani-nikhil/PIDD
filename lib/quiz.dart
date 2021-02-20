import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final int _questionIndex;
  final List<Map<String, Object>> _questions;
  final Function _answerQuestion;
  Quiz(@required this._questions, @required this._answerQuestion,
      @required this._questionIndex);
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Question(_questions[_questionIndex]['questionText']),
        ...(_questions[_questionIndex]['answers'] as List<Map>)
            .map((answer) =>
                Answer(answer['text'], _answerQuestion, answer['score']))
            .toList()
      ],
    ));
  }
}
