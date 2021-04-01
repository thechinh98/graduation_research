import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';

class FlashGameObject extends GameObject {
  late Face answer;
  FlashGameObject.fromQuestion(Question questionDb) : super.fromQuestion(questionDb) {
    answer = Face()..content = questionDb.choices!.first.content;
  }

  onAnswer() {
    if (gameObjectStatus == GameObjectStatus.answered) {
      return;
    } else {
      gameObjectStatus = GameObjectStatus.answered;
      questionStatus = QuestionStatus.answeredCorrect;
    }
  }

}