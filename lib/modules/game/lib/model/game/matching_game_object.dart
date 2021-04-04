import 'package:game/model/core/choice.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/screen/study/game_view/matching/matching_view.dart';

class MatchingGameObject extends GameObject{
      List<Question> questions = [];
      int clickNumAvailable = 0;
      MatchingGameObject.fromQuestions(List<Question> _question) : super.fromQuestion(_question.first){
        _question.forEach((element) {
          if(element.content!.isEmpty || element.choices!.isEmpty) return;
          questions.add(Question()..content = element.content..id = element.id);
          if(element.choices!.isNotEmpty){
            Choice correctChoice = element.choices!.firstWhere((element) => element.isCorrect);
            questions.add(Question()..content = element.content..id = element.id);
          }
        });
        questions.shuffle();
        clickNumAvailable = questions.length + 2;
      }
      onAnswer(MatchingAnswerParams params){
        clickNumAvailable -= 2;
        final isMatch = params.question1.id == params.question2.id;
        if(isMatch){
          params.question1.questionStatus = QuestionStatus.answeredCorrect;
          params.question2.questionStatus = QuestionStatus.answeredCorrect;
          params.onAnswerCorrect();
        } else {
          params.question1.questionStatus = QuestionStatus.answeredIncorrect;
          params.question2.questionStatus = QuestionStatus.answeredIncorrect;
          params.onAnswerWrong();
        }
        if(winGame()){
          gameObjectStatus = GameObjectStatus.answered;
          questionStatus = QuestionStatus.answeredCorrect;
        } else if(clickNumAvailable == 0){
          gameObjectStatus = GameObjectStatus.answered;
          questionStatus = QuestionStatus.answeredIncorrect;
          questions.forEach((element) {
            element.questionStatus = QuestionStatus.answeredIncorrect;
          });
        }
        }

        bool winGame(){
          return questions.where((element) => element.questionStatus == QuestionStatus.answeredCorrect).length == questions.length;
        }
        @override
  reset() {
    // TODO: implement reset
    super.reset();
    questions.forEach((element) {
      element.questionStatus = QuestionStatus.notAnswerYet;
    });
    clickNumAvailable = questions.length + 2;
  }
}
