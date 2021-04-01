// import 'package:flutter/material.dart';
//
// class NavigationService {
//   factory NavigationService() {
//     if (_instance == null) {
//       _instance = NavigationService._getInstance();
//     }
//     return _instance!;
//   }
//
//   static NavigationService? _instance;
//   NavigationService._getInstance();
//
//   GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
//
//   GlobalKey<NavigatorState> get navigationKey => _navigationKey;
//
//   void pop() {
//     return _navigationKey.currentState!.pop();
//   }
//
//   void popUtils(String routeName) {
//     return _navigationKey.currentState!.popUntil(ModalRoute.withName(routeName));
//   }
//
//   Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
//     return _navigationKey.currentState!
//         .pushNamed(routeName, arguments: arguments);
//   }
//
//   Future<dynamic> pushReplacementNamed(String routeName, {dynamic arguments}) {
//     return _navigationKey.currentState!
//         .pushReplacementNamed(routeName, arguments: arguments);
//   }
//
//   Future<dynamic> popAndPushNamed(String routeName, {dynamic arguments}) {
//     return _navigationKey.currentState!
//         .popAndPushNamed(routeName, arguments: arguments);
//   }
// }
