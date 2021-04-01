import 'package:game/service/game_service.dart';

class GameServiceInitializer {
  factory GameServiceInitializer() {
    if (_instance == null) {
      _instance = GameServiceInitializer._getInstance();
    }
    return _instance!;
  }

  static GameServiceInitializer? _instance;
  GameServiceInitializer._getInstance();
  
  late final GameService gameService;

  init(gameService) {
    this.gameService = gameService;
  }
}