import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';

class Progress {
  int total = 0;
  int done = 0;
  int notDone = 0;
  int correct = 0;
  int inCorrect = 0;
  Progress();

  Progress.calcProgress(List<GameObject> gameObjects) {
    for (var o in gameObjects) {
      calcProgressForNormalQues(o);
      total++;
    }
  }

  calcProgressForNormalQues(GameObject gameObjects) {
    if (gameObjects.gameObjectStatus == GameObjectStatus.answered) {
      if (gameObjects.questionStatus == QuestionStatus.answeredCorrect) {
        correct++;
      } else {
        inCorrect++;
      }
      done++;
    } else {    
      notDone++;
    }
  }

  @override
  String toString() {
    return "progress: done :$done -- notdone: $notDone -- correct: $correct -- -- mistake: $inCorrect -- total: $total";
  }
}