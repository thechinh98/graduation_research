import 'package:game/model/core/question.dart';
import 'package:flutter/material.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/matching_game_object.dart';
import 'package:game/screen/study/game_view/game_item_view.dart';
import 'package:game/screen/study/study_screen.dart';

class MatchingView extends StatefulWidget {
  final MatchingGameObject gameObject;
  final OnAnswer onAnswer;

  MatchingView({Key? key, required this.gameObject, required this.onAnswer})
      : super(key: key);

  @override
  _MatchingViewState createState() => _MatchingViewState();
}

class _MatchingViewState extends State<MatchingView> {
  MatchingGameObject get gameObject => widget.gameObject;

  OnAnswer get onAnswer => widget.onAnswer;

  Question? previousQuestion;
  Question? currentQuestion;
  bool enableClick = true;

  static const List<Color> colorList = [
    Color(0xff66CDAA),
    Color(0xff87CEFA),
    Color(0xffFFE4E1)
  ];

  Map<String, Color> questionColorMap = {};

  @override
  Widget build(BuildContext context) {
    return _buildTable(gameObject.questions);
  }

  _buildTable(List<Question> data, {int nColumns = 2}) {
    if (data.isEmpty) {
      return;
    }
    final iterator = data.iterator;
    int nRows = (data.length / nColumns).ceil();
    List<Widget> rows = [];
    for (int i = 0; i < nRows; i++) {
      List<Widget> cellsEachRow = [];
      int tmp = data.length - (i * nColumns);
      int nCellInThisRow = tmp < nColumns ? tmp : nColumns;
      for (int j = 0; j < nCellInThisRow; j++) {
        iterator.moveNext();
        final question = iterator.current;
        final cellColor = _getCellColor(question);
        cellsEachRow.add(
          Expanded(
            child: InkWell(
              onTap: () {
                _onCellTap(question);
              },
              child: MyCard(
                text: question.content!,
                color: cellColor,
              ),
            ),
          ),
        );
      }
      for (int k = 0; k < (nColumns - nCellInThisRow); k++) {
        cellsEachRow.add(Expanded(child: Container()));
      }
      rows.add(Expanded(
        child: Row(
          children: cellsEachRow,
        ),
      ));
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: rows,
    );
  }

  Color _getCellColor(Question question) {
    if (question.questionStatus == QuestionStatus.answeredIncorrect) {
      return Colors.orange;
    } else if (question.questionStatus == QuestionStatus.answeredCorrect) {
      Color? color = questionColorMap[question.id!];
      if (color == null) {
        color = colorList[questionColorMap.length % colorList.length];
        questionColorMap[question.id!] = color;
      }
      return color;
    } else {
      if (question == currentQuestion) {
        return Colors.grey[500]!;
      } else {
        return Colors.white;
      }
    }
  }

  _onCellTap(Question question) {
    if (!enableClick || gameObject.gameObjectStatus == GameObjectStatus.answered) {
      return;
    }
    setState(() {
      previousQuestion = currentQuestion;
      currentQuestion = question;
      if (previousQuestion != null) {
        enableClick = false;
        onAnswer(AnswerType.matching, MatchingAnswerParams(previousQuestion!, currentQuestion!, onAnswerCorrect: _onAnswerCorrect, onAnswerWrong: _onAnswerWrong));
      }
    });
  }

  _onAnswerCorrect() {
    previousQuestion = null;
    currentQuestion = null;
    enableClick = true;
  }

  _onAnswerWrong() {
    final q1 = previousQuestion;
    final q2 = currentQuestion;
    previousQuestion = null;
    currentQuestion = null;
    enableClick = true;
    Future.delayed(Duration(milliseconds: 500), () {
      if (gameObject.questionStatus == QuestionStatus.notAnswerYet) {
        setState(() {
          q1!.questionStatus = QuestionStatus.notAnswerYet;
          q2!.questionStatus = QuestionStatus.notAnswerYet;
        });
      }
    });
  }
}

class MyCard extends StatelessWidget {
  final String text;
  final Color color;

  MyCard({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6.0),
      color: color,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class MatchingAnswerParams {
  Question question1;
  Question question2;
  Function onAnswerCorrect;
  Function onAnswerWrong;

  MatchingAnswerParams(this.question1, this.question2, {required this.onAnswerCorrect, required this.onAnswerWrong});
}