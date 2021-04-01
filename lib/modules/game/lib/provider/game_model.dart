import 'package:flutter/material.dart';
import 'package:game/model/game/game_object.dart';
import 'package:game/model/game/progress.dart';
import 'package:game/repository/sql_repository.dart';
import 'package:game/service/game_service.dart';

enum GameType {
  QUIZ,
  FLASH_CARD,
  SPELLING,
  MATCHING,
}

class GameModel extends ChangeNotifier {
  // SqfliteRepository sqlRepo = SqfliteRepository();
  late GameService gameService;
  List<GameObject>? listGames;
  GameObject? currentGames;
  Progress gameProgress = Progress();
  bool get isLoading => listGames == null;
  bool isFinishGame = false;
  List<GameObject> listDone = <GameObject>[];

  resetListGame() {
    listGames = [];
    listDone = [];
    currentGames = null;
    gameProgress = Progress();
    isFinishGame = false;
  }
}

class GamePlay {
  void onContinue(){}
  void onFinish(){}
  void calcProgress(){}
}
