import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';

class ParaGameObject extends GameObject {
  List<QuizGameObject> children = [];
  List<int> childrenIndex = [];

  ParaGameObject.fromQuestion(Question questionDb)
      : super.fromQuestion(questionDb);
}
