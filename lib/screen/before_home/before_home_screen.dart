import 'package:demo_game/route/navigation_services.dart';
import 'package:demo_game/route/routes.dart';
import 'package:flutter/material.dart';

class BeforeHomeScreen extends StatefulWidget {
  BeforeHomeScreen({Key? key}) : super(key: key);

  @override
  _BeforeHomeScreenState createState() => _BeforeHomeScreenState();
}

class _BeforeHomeScreenState extends State<BeforeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Before Home'),
        leading: Container(),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Go To Home'),
          onPressed: () {
            NavigationService().pushNamed(ROUTE_HOME);
          },
        ),
      ),
    );
  }
}