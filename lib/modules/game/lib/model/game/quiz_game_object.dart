import 'package:game/model/core/choice.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/screen/study/game_view/quiz/quiz_view.dart';
class QuizGameObject extends GameObject {
  ParaGameObject? parent;
  String? questionId;
  late List<Choice> choices;
  List<Choice> answered = [];
  int correctNum = 0;

  QuizGameObject.fromQuestion(Question questionDb) : super.fromQuestion(questionDb) {
    questionId = questionDb.id;
    choices = questionDb.choices ?? <Choice>[];
    getCorrectNum();
  }

  getCorrectNum() {
    int i = 0;
    choices.forEach((element) {
      if (element.isCorrect) i++;
      if (element.selected) answered.add(element);
    });
    correctNum = i;
  }

  onAnswer(QuizAnswerParams params) {
    switch (params.type) {
      case QuizAnswerType.choice_click:
        if (gameObjectStatus == GameObjectStatus.answered) {
          return;
        }
        Choice clicked = params.choice;
        updateProgress(clicked);
        break;
      case QuizAnswerType.continue_click:
        break;
      default:
        break;
    }
  }

  updateProgress(Choice choice) {
    if (answered.contains(choice)) {
      return;
    }

    choice.selected = true;
    answered.add(choice);
    // always change when length == correctNum so it will not affect
    // if (answered.isNotEmpty && answered.length > correctNum) {
    //   Choice oldChoice = answered[0];
    //   oldChoice.selected = false;
    //   Choice x = choices.firstWhere((element) => element.id == oldChoice.id)
    //     ..selected = false;
    //   print('CHINHLT: Choice with id: ${x.id} is unselected');
    //   answered.removeAt(0);
    // }
    if (answered.length == correctNum) {
     gameObjectStatus = GameObjectStatus.answered;
      int selectedCorrect = 0;
      answered.forEach((element) {
        if (element.isCorrect) selectedCorrect++;
      });
      if (selectedCorrect == correctNum) {
        questionStatus = QuestionStatus.answeredCorrect;
      } else {
        questionStatus = QuestionStatus.answeredIncorrect;
      }
    }
  }

  @override
  reset() {
    super.reset();
    answered = [];
    choices.forEach((element) {
      if (element.selected) {
        element.selected = false;
      }
    });
  }
}