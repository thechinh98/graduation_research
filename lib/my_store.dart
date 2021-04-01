import 'package:demo_game/game_service_impl.dart';
import 'package:game/provider/audio_model.dart';
import 'package:game/provider/study_game_model.dart';
import 'package:game/service/service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MyStore {
  factory MyStore() {
    if (_instance == null) {
      _instance = MyStore._getInstance();
    }
    return _instance!;
  }

  static MyStore? _instance;
  MyStore._getInstance();

  // Declare list of model here
  late StudyGameModel studyGameModel;
  late AudioModel audioModel;

  init() async {
    // initialize all the services before init any model
    final gameService = GameServiceImpl();
    GameServiceInitializer().init(gameService);

    studyGameModel = StudyGameModel();
    audioModel = AudioModel();
  }

  List<SingleChildWidget> provides() => [
    ChangeNotifierProvider(create: (_) => studyGameModel),
    ChangeNotifierProvider(create: (_) => audioModel),
  ];

}