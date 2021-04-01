// import 'package:game/provider/audio_model.dart';
// import 'package:game/provider/study_game_model.dart';
//
// import 'package:provider/provider.dart';
// import 'package:provider/single_child_widget.dart';
//
// class AppProvider {
//   factory AppProvider() {
//     if (_instance == null) {
//       _instance = AppProvider._getInstance();
//     }
//     return _instance!;
//   }
//
//   static AppProvider? _instance;
//   AppProvider._getInstance();
//
//   // Declare list of model here
//   late StudyGameModel studyGameModel;
//   late AudioModel audioModel;
//
//   init() {
//     studyGameModel = StudyGameModel();
//     audioModel = AudioModel();
//   }
//
//   List<SingleChildWidget> get provides => [
//     ChangeNotifierProvider(create: (_) => studyGameModel),
//     ChangeNotifierProvider(create: (_) => audioModel),
//   ];
//
// }