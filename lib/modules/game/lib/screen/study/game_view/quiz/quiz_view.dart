// Flutter imports:
import 'package:game/component/new_my_sound.dart';
import 'package:flutter/material.dart';
import 'package:game/component/text_content.dart';
import 'package:game/model/core/choice.dart';
import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/screen/study/game_view/game_item_view.dart';
import 'package:game/screen/study/study_screen.dart';

class QuizView extends StatelessWidget {
  final QuizGameObject gameObject;
  final ScrollController _scrollController = ScrollController();
  final OnAnswer? onAnswer;

  QuizView({this.onAnswer, required this.gameObject});

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          _renderSound(),
          _renderParentQuestion(),
          _renderQuestion(),
          _buildListChoices(context),
          _buildExplain(),
        ],
      ),
    );
  }

  Widget _renderParentQuestion() {
    if (gameObject.parent != null) {
      return TextContent(
        face: gameObject.parent!.question,
        textStyle: TextStyle(fontSize: 20),
      );
    }
    return Container();
  }

  Container _renderQuestion() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: TextContent(
        face: gameObject.question,
        textStyle: TextStyle(fontSize: 20),
      ),
    );
  }

  Container _buildExplain() {
    if (gameObject.gameObjectStatus == GameObjectStatus.answered &&
        gameObject.questionStatus == QuestionStatus.answeredCorrect) {
      if (gameObject.explain == null) {
        if (gameObject is QuizGameObject && gameObject.parent != null) {
          if (gameObject.parent!.explain != null) {
            return Container(
              width: double.infinity,
              child: Center(
                child: TextContent(
                  face: gameObject.parent!.explain!,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            );
          }
        }
        return Container();
      }
      return Container(
        width: double.infinity,
        child: Center(
          child: TextContent(
            face: gameObject.explain!,
            textStyle: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _renderSound() {
    if (gameObject.parent != null &&
        gameObject.parent!.question.sound != null &&
        gameObject.parent!.question.sound!.isNotEmpty) {
      return NewGameSound(
        disabled: onAnswer == null ? true : false,
        questionId: gameObject.parent!.id!,
        key: Key(gameObject.parent!.id.toString() + gameObject.id.toString()),
      );
    } else if (gameObject.question.sound != null &&
        gameObject.question.sound!.isNotEmpty) {
      return NewGameSound(
        disabled: onAnswer == null ? true : false,
        questionId: gameObject.id!,
        key: Key(gameObject.id.toString()),
      );
    } else
      return Container();
  }

  Widget _buildListChoices(BuildContext context) {
    List<Widget> choiceUI = [];
    for (var i = 0; i < gameObject.choices.length; i++) {
      Choice choice = gameObject.choices[i];
      Face choiceFace = Face(content: choice.content, id: choice.id);
      choiceUI.add(
        InkWell(
          onTap: () => choiceClicked(choice),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
                color: _getChoiceColor(choice),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ListTile(
              title: TextContent(
                face: choiceFace,
                textStyle: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.black),
              ),
            ),
          ),
        ),
      );
    }
    return Column(children: choiceUI);
  }

  void choiceClicked(Choice e) {
    if (gameObject.gameObjectStatus == GameObjectStatus.answered) {
      return;
    }
    QuizAnswerParams params = QuizAnswerParams(
        type: QuizAnswerType.choice_click,
        choice: e,
        questionId: gameObject.questionId);
    if (onAnswer != null) {
      onAnswer!(AnswerType.quiz, params);
    }
    scrollToBottom();
  }

  Color _getChoiceColor(Choice e) {
    if (gameObject.gameObjectStatus == GameObjectStatus.answered) {
      if (e.selected) {
        if (e.isCorrect) {
          return Colors.blueAccent;
        } else {
          return Colors.red;
        }
      } else {
        return Colors.white;
      }
    } else {
      if (gameObject.correctNum > 1) {
        if (e.selected) {
          return Colors.grey;
        }
      }
      return Colors.white;
    }
  }
}

enum QuizAnswerType { choice_click, continue_click }

class QuizAnswerParams {
  QuizAnswerType type;
  Choice choice;
  String? questionId;

  QuizAnswerParams({
    required this.type,
    required this.choice,
    required this.questionId,
  });
}
