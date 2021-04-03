import 'package:game/model/core/choice.dart';
import 'package:game/model/core/face.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/screen/study/game_view/spelling/spelling_view.dart';

class SpellingGameObject extends GameObject {
  late Face answer;
  String userInput = '';
  SpellingGameObject.fromQuestion(Question questionDb) : super.fromQuestion(questionDb){
    String content = questionDb.content!.replaceAll(' ', '');
    answer = Face()..content = content..id = questionDb.id;
    if(questionDb.choices!.isNotEmpty){
      Choice correctChoice = questionDb.choices!.firstWhere((element) => element.isCorrect);
      question = Face()..content = correctChoice.content..id = questionDb.id;
    }
  }
  onAnswer(SpellAnswerParams params){
    switch(params.type) {
      case SpellCardAnswerType.send_answer:
        if(gameObjectStatus == GameObjectStatus.answered){
          return;
        }
        userInput = params.answer;
        if(userInput.toLowerCase() == answer.content!.toLowerCase()){
          gameObjectStatus = GameObjectStatus.answered;
          questionStatus = QuestionStatus.answeredCorrect;
        } else {
          gameObjectStatus = GameObjectStatus.answered;
          questionStatus = QuestionStatus.answeredIncorrect;
        }
        break;
      case SpellCardAnswerType.user_input_value:
        userInput = params.answer;
        break;
      default:
        break;
    }
  }
  @override
  reset() {
    super.reset();
    userInput = '';
    userInput = userInput.padRight(answer.content!.length,'_');
  }
}