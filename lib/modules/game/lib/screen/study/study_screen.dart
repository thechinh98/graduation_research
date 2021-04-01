import 'package:game/model/core/question.dart';
import 'package:game/model/game/flash_game_object.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/quiz_game_object.dart';
import 'package:game/provider/audio_model.dart';

import 'package:flutter/material.dart';
import 'package:game/provider/study_game_model.dart';
import 'package:game/screen/study/game_view/game_item_view.dart';
import 'package:game/screen/study/study_logic.dart';
import 'package:game/screen/study/study_progress.dart';
import 'package:provider/provider.dart';

enum AnswerType { quiz, spelling, matching, flash }
enum StudyType { study, practice }

class StudyScreen extends StatefulWidget {
  final String topicId;

  StudyScreen(this.topicId);

  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with TickerProviderStateMixin {
  String get topicId => widget.topicId;

  late StudyLogic studyLogic;
  late StudyGameModel gameModel;
  bool isSoundDataLoaded = false;

  //animation
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    print('CHINHLT: Study Screen - init State: StudyModel: ${context.read<StudyGameModel>()}');
    studyLogic = StudyLogic(context: context, topicId: topicId);

    gameModel = context.read<StudyGameModel>();
    gameModel.addListener(listener);

    studyLogic.loadData();

    //init animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _animation2 = Tween<Offset>(begin: Offset.zero, end: Offset(-1.0, 0.0))
        .animate(_controller);
    super.initState();
  }

  int firstRun = 0;
  listener() async {
    final audioModel = context.read<AudioModel>();
    if (gameModel.listGames!.isNotEmpty) {
      if (audioModel.sounds.isEmpty && firstRun == 0) {
        firstRun++;
        List<NewSoundData> _sounds = [];
        gameModel.listGames!.forEach((element) {
          _sounds.add(NewSoundData.fromGameObject(
              questionId: element.id, sound: element.question.sound));

          if (element is QuizGameObject && element.parent != null) {
            _sounds.add(NewSoundData.fromGameObject(
                questionId: element.parent!.id,
                sound: element.parent!.question.sound));
          }
        });
        await audioModel.loadData(_sounds);
        setState(() {
          isSoundDataLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: SafeArea(
        child: Consumer(
          builder: (_, StudyGameModel gameModel, __) {
            if (gameModel.isFinishGame) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Finished!'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Continue'),
                      onPressed: () {
                        studyLogic.navigateAfterFinishingStudy();
                      },
                    ),
                  ],
                ),
              );
            }

            GameObject? previousGame = gameModel.previousGame;
            gameModel.previousGame = gameModel.currentGames;
            print('CHINHLT: current game: ${gameModel.currentGames}');

            return Column(
              children: <Widget>[
                _buildStudyProgress(),
                Expanded(
                  child: _renderCurrentGame(
                    gameModel.currentGames,
                    previousGame,
                  ),
                ),
                if (gameModel.currentGames is! FlashGameObject) _renderContinueBtn(),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildStudyProgress() {
    var progress = context.read<StudyGameModel>().gameProgress;
    if (progress.total == 0) return SizedBox();
    return StudyProgressWidget(
      correct: progress.correct,
      total: progress.total,
    );
  }

  Widget _renderCurrentGame(
    GameObject? _current,
    GameObject? _pre,
  ) {
    if (_current == null) {
      return Container();
    }
    return GameItemView(
      gameObject: _current,
      onAnswer: studyLogic.onAnswer,
    );
  }

  void startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  Container _renderContinueBtn() {
    GameObject? currentGame = context.read<StudyGameModel>().currentGames;
    if (currentGame == null)
      return Container(
        child: null,
      );
    Color _color = Theme.of(context).backgroundColor;
    if (currentGame.gameObjectStatus == GameObjectStatus.waiting) {
      return Container(child: null);
    }
    if (currentGame.questionStatus == QuestionStatus.answeredCorrect) {
      _color = Colors.blueAccent;
      if (context.read<StudyGameModel>().listGames!.isEmpty) {}
    } else if (currentGame.questionStatus == QuestionStatus.answeredIncorrect) {
      _color = Colors.red;
    }
    return Container(
      child: MaterialButton(
        onPressed: studyLogic.onContinue,
        clipBehavior: Clip.antiAlias,
        animationDuration: Duration(milliseconds: 200),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: _color,
              border: Border.all(
                color: _color,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Center(
            child: Text(
              (currentGame.questionStatus == QuestionStatus.answeredCorrect &&
                      context.read<StudyGameModel>().listGames!.isEmpty)
                  ? 'Finish'
                  : 'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    gameModel.removeListener(listener);
    super.dispose();
  }
}
