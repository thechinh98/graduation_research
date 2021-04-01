import 'package:game/model/core/choice.dart';
import 'package:game/model/core/question.dart';
import 'package:game/model/game/flash_game_object.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/matching_game_object.dart';
import 'package:game/model/game/para_game_object.dart';
import 'package:game/model/game/progress.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/model/game/spelling_game_object.dart';
import 'package:game/provider/game_model.dart';
import 'package:game/screen/study/game_view/quiz/quiz_view.dart';
import 'package:game/screen/study/study_screen.dart';
import 'package:game/service/service.dart';

class StudyGameModel extends GameModel implements GamePlay {
  List<Question> questions = [];
  String currentTopic = '';
  GameObject? previousGame;
  List<GameObject> listDone = [];

  StudyGameModel() {
    this.gameService = GameServiceInitializer().gameService;
  }

  loadData({required String topicId}) async {
    resetListGame();
    questions.clear();
    this.currentTopic = topicId;
    List<Question> quesDb = [];

    print('CHINHLT: StudyGameModel- load data - topic ID: $topicId');

    quesDb = await gameService.loadQuestionsByParentId(parentId: topicId);

    print('CHINHLT: StudyGameModel- load data - quesDb size: ${quesDb.length}');

    Map<String, Question> mapQuestionHasChild = {};
    // Map<String, ParaGameObject> mapGameObjectHasChild = {};
    quesDb.forEach((element) {
      if (element.hasChild) {
        mapQuestionHasChild.putIfAbsent(element.id!, () => element);
        // mapGameObjectHasChild.putIfAbsent(element.id, () => ParaGameObject.fromQuestion(element));
      } else {
        questions.add(element);
      }
    });
    
    List<Question> childQuestions = [];
    if (mapQuestionHasChild.isNotEmpty) {
      childQuestions = await gameService.loadChildQuestionList(mapQuestionHasChild);
      childQuestions.forEach((element) {
        if (element.choices!.isNotEmpty) {
          Question? parentQuestion = mapQuestionHasChild[element.parentId!];
          if (parentQuestion != null) {
            element.parentQues = parentQuestion;
            element.sound = parentQuestion.sound;
          }
          questions.add(element);
        } else {
          // SPELL GAME
        }
      });
    }

    // generateGame(questions.sublist(0, 6), StudyType.practice, choicesNum: 4);
    generateGame(questions, StudyType.practice, choicesNum: 4);
    listGames!.sort((a, b) => (a.orderIndex! < b.orderIndex! ? -1 : 1));

    // notifyListeners();
    print('Phungtd: StudyGameModel- load data - listGame size: ${listGames!.length}');
    calcProgress();
    notifyListeners();
    onContinue();
  }

  generateGame(List<Question> questions, StudyType type, {int? choicesNum}) {
    if (type == StudyType.practice) {
      
      final iterator = questions.iterator;
      while (iterator.moveNext()) {
        final question = iterator.current;

        // TODO set game type
        final gameType = _getGameType();
        switch (gameType) {
          case GameType.QUIZ:
          createQuizGameObject(question, choicesNum);
            break;
          case GameType.FLASH_CARD:
            final flashGame = FlashGameObject.fromQuestion(question);
            listGames!.add(flashGame);
            break;
          default:
            break;
        }
      }
    }
  }

  GameType _getGameType() {
    return GameType.QUIZ;
  }

  createQuizGameObject(Question question, int? choicesNum) {
    final quiz = QuizGameObject.fromQuestion(question);
    if (choicesNum != null) {
      final numOfFakeChoices = choicesNum - quiz.choices.length < questions.length - 1 ? choicesNum - quiz.choices.length : questions.length - 1;
      if (numOfFakeChoices > 0) {
        int index = questions.indexOf(question);
        List<int> availableIndexes = [];
        for (int i = 0; i < questions.length; i++) {
          if (i != index) {
            availableIndexes.add(i);
          }
        }
        availableIndexes.shuffle();
        for (int j = 0; j < numOfFakeChoices; j++) {
          final choiceToClone = questions[availableIndexes.removeAt(0)].choices![0];
          final fakeChoice = Choice.cloneWrongChoice(choiceToClone);
          quiz.choices.add(fakeChoice);
        }
      }
    }
    quiz.choices.shuffle();

    Map<String, ParaGameObject> mapHasChild = {};
    if (question.parentQues != null) {
      String? key = question.parentQues!.id;
      if (!mapHasChild.containsKey(key)) {
        ParaGameObject paraGameObject = ParaGameObject.fromQuestion(question.parentQues!);
        quiz.parent = paraGameObject;
        mapHasChild.putIfAbsent(key!, () => paraGameObject);
      } else {
        quiz.parent = mapHasChild[key!];
      }
    }

    listGames!.add(quiz);
  }

  onAnswer<T>(AnswerType type, T params) async {
    switch (type) {
      case AnswerType.quiz:
        (currentGames as QuizGameObject).onAnswer(params as QuizAnswerParams);
        break;
      default:
        break;
    }
    updateGameProgress();
    calcProgress();
    if (currentGames is FlashGameObject) {
      onContinue();
    } else {
      notifyListeners();
    }
  }

  updateGameProgress<T>([T? params]) {
    if (currentGames!.gameObjectStatus == GameObjectStatus.answered) {
      if (currentGames!.questionStatus == QuestionStatus.answeredCorrect) {
        listDone.add(currentGames!);
      } else {
        listGames!.add(currentGames!);
      }
    }
  }

  @override
  calcProgress() {
    List<GameObject> resultList = [];
    resultList.addAll(listGames!);
    resultList.addAll(listDone);
    if (currentGames != null &&
        currentGames!.gameObjectStatus == GameObjectStatus.waiting &&
        (currentGames is QuizGameObject || currentGames is MatchingGameObject)) {
      resultList.add(currentGames!);
    }
    gameProgress = Progress.calcProgress(resultList);
  }

  @override
  void onContinue({Function? callBack}) {
    if (isFinished()) {
      onFinish();
      return;
    }
    if (listGames!.isEmpty) {
      return;
    }
    currentGames = listGames!.removeAt(0);
    if (currentGames!.gameObjectStatus== GameObjectStatus.answered) {
      if (currentGames!.questionStatus == QuestionStatus.answeredIncorrect) {
        currentGames!.reset();
      }
    }

    if (callBack != null) {
      callBack();
    }
    notifyListeners();
  }

  @override
  void onFinish() {
    isFinishGame = true;
    notifyListeners();
  }

  bool isFinished() {
    return listDone.isNotEmpty && listGames!.isEmpty;
  }

}
