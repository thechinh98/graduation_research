// import 'package:game/screen/home/home_screen.dart';
// import 'package:game/screen/study/study_screen.dart';
//
// import 'routes.dart';
// import 'package:flutter/material.dart';
//
// Route<dynamic> generateRoute(RouteSettings settings) {
//   Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
//   switch (settings.name) {
//     case ROUTER_HOME:
//       return _getPageRoute(
//         routeName: settings.name!,
//         viewToShow: HomeScreen(),
//       );
//     case ROUTER_STUDY:
//       String topicId = arguments!['topicId'];
//       return _getPageRoute(
//         routeName: settings.name!,
//         viewToShow: StudyScreen(topicId),
//       );
//     default: return MaterialPageRoute(
//       builder: (_) => Scaffold(
//         body: Center(
//           child: Text('No route defined for ${settings.name}')),
//       ),
//     );
//   }
// }
//
// PageRoute _getPageRoute({required String routeName, required Widget viewToShow}) {
//   return MaterialPageRoute(
//       settings: RouteSettings(
//         name: routeName,
//       ),
//       builder: (_) => viewToShow
//   );
// }