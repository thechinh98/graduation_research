import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';

enum GameObjectStatus { waiting, answered, skip, locked }

class GameObject {
  String? id;
  late Face question;
  Face? explain;   // used in flash game
  late Face hint;
  GameObjectStatus gameObjectStatus = GameObjectStatus.waiting;
  QuestionStatus questionStatus = QuestionStatus.notAnswerYet;
  double? orderIndex;

  // GameObject();

  GameObject.fromQuestion(Question questionDb) {
    id = questionDb.id;
    question = Face.fromQuestion(questionDb);
    if (questionDb.explain != null && questionDb.explain!.isNotEmpty) {
      explain = Face(content: questionDb.explain);
    }
    if (questionDb.hint != null && questionDb.hint!.isNotEmpty) {
      hint = Face(content: questionDb.hint);
    }

    orderIndex = questionDb.orderIndex;
  }

  reset() {
    gameObjectStatus = GameObjectStatus.waiting;
    questionStatus = QuestionStatus.notAnswerYet;
  }
}