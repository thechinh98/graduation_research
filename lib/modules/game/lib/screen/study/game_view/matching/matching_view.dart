import 'package:game/model/core/question.dart';

class MatchingAnswerParams {
  Question question1;
  Question question2;
  Function onAnswerCorrect;
  Function onAnswerWrong;

  MatchingAnswerParams(this.question1, this.question2, {required this.onAnswerCorrect, required this.onAnswerWrong});
}