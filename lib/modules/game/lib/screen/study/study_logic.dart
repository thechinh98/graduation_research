import 'package:flutter/material.dart';
import 'package:game/provider/study_game_model.dart';
import 'package:game/screen/study/study_screen.dart';
import 'package:game/service/game_service.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';

class StudyLogic {
  final String topicId;
  late StudyGameModel studyGameModel;
  late GameService gameService;
  BuildContext context;

  StudyLogic({required this.context, required this.topicId}) {
    studyGameModel = context.read<StudyGameModel>();
    gameService = GameServiceInitializer().gameService;
  }

  loadData() async {
    await studyGameModel.loadData(topicId: topicId);
  }

  Future onAnswer<T>(AnswerType type, [T? params]) async {
    await studyGameModel.onAnswer(type, params);
  }

  onContinue() {
    studyGameModel.onContinue();
  }

  navigateAfterFinishingStudy() {
    gameService.navigateAfterFinishingStudy();
  }
}