import 'package:demo_game/screen/after_study/after_study_screen.dart';
import 'package:demo_game/screen/before_home/before_home_screen.dart';
import 'package:game/screen/home/home_screen.dart';
import 'package:demo_game/route/routes.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  Map<String, dynamic>? arguments = settings.arguments as Map<String, dynamic>?;
  switch (settings.name) {
    case ROUTE_BEFORE_HOME:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: BeforeHomeScreen(),
      );
    case ROUTE_HOME:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: HomeScreen(),
      );
    case ROUTE_AFTER_STUDY:
      return _getPageRoute(
        routeName: settings.name!,
        viewToShow: AfterStudyScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}

PageRoute _getPageRoute(
    {required String routeName, required Widget viewToShow}) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
