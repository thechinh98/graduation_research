import 'package:flutter/material.dart';
import 'package:game/component/text_content.dart';
import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/spelling_game_object.dart';
import 'package:game/screen/study/game_view/game_item_view.dart';
import 'package:game/screen/study/study_screen.dart';
import 'package:game/utils/constant.dart';
class SpellAnswerParams {
  SpellCardAnswerType type;
  String answer;
  String? questionId;
  bool isCorrect = false;

  SpellAnswerParams(
      {required this.type, required this.answer, required this.questionId});
}


enum SpellCardAnswerType { send_answer, user_input_value, continue_click }

class SpellingView extends StatefulWidget {
  final SpellingGameObject gameObject;
  final OnAnswer onAnswer;

  SpellingView({Key? key, required this.gameObject, required this.onAnswer})
      : super(key: key);

  @override
  _SpellingViewState createState() => _SpellingViewState();
}

class _SpellingViewState extends State<SpellingView> {
  SpellingGameObject get gameObject => widget.gameObject;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _questionBlock(),
        Spacer(),
        _answerBlock(),
        _userAnswerBlock(),
        _inputField(),
      ],
    );
  }

  _questionBlock() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextContent(
        face: Face(content: gameObject.question.content),
        textStyle: TextStyle(
            fontFamily: AppFont.FONT_SF_PRO,
            fontSize: 20,
            fontWeight: FontWeight.w700),
      ),
    );
  }

  _answerBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      child: Visibility(
        child:
        _buildAnswer(gameObject.answer.content!, gameObject.questionStatus),
        visible:
        gameObject.questionStatus == QuestionStatus.answeredIncorrect ||
            gameObject.questionStatus == QuestionStatus.answeredCorrect
            ? true
            : false,
      ),
    );
  }

  _userAnswerBlock() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: _buildAnswer(gameObject.userInput, QuestionStatus.notAnswerYet),
    );
  }

  _inputField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: <Widget>[
          TextField(
            controller: _controller,
            onChanged: (value) => _onTextChange(value),
            maxLength: gameObject.answer.content?.length ?? 0,
            onSubmitted: (value) => _onSubmit(value),
            style: Theme.of(context).textTheme.subtitle1,
            readOnly: gameObject.questionStatus ==
                QuestionStatus.answeredIncorrect ||
                gameObject.questionStatus == QuestionStatus.answeredCorrect
                ? true
                : false,
            decoration: InputDecoration(
              counterText: "",
              contentPadding: EdgeInsets.only(left: 8),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () => gameObject.questionStatus ==
                  QuestionStatus.answeredIncorrect ||
                  gameObject.questionStatus ==
                      QuestionStatus.answeredCorrect
                  ? null
                  : _onSubmit(_controller.text),
              icon: Icon(
                Icons.send,
                color: Theme.of(context).buttonColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnswer(String value, QuestionStatus status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: value
          .split('')
          .map(
            (text) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: _getColor(status)),
          ),
        ),
      )
          .toList(),
    );
  }

  Color _getColor(QuestionStatus status) {
    switch (status) {
      case QuestionStatus.answeredIncorrect:
        return Colors.red;
      case QuestionStatus.answeredCorrect:
        return Color(0xff44C402);
      default:
        return Theme.of(context).textTheme.subtitle1!.color!;
    }
  }

  _onTextChange(String value) {
    try {
      if (value.length > gameObject.answer.content!.length) {
        return;
      }
      gameObject.userInput =
          value.padRight(gameObject.answer.content!.length, '_');
      SpellAnswerParams params = SpellAnswerParams(
          type: SpellCardAnswerType.user_input_value,
          answer: value.padRight(gameObject.answer.content!.length, '_'),
          questionId: gameObject.question.id);
      widget.onAnswer(AnswerType.spelling, params);
    } on Exception catch (exception) {}
  }

  _onSubmit(String value) {
    FocusScope.of(context).unfocus();
    if (value.length >= gameObject.userInput.length) {
      _controller.text = '';
      SpellAnswerParams params = SpellAnswerParams(
        type: SpellCardAnswerType.send_answer,
        answer: value,
        questionId: widget.gameObject.id,
      );
      widget.onAnswer(AnswerType.spelling, params);
    }
  }
}