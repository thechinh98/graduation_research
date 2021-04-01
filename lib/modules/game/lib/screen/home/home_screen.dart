import 'package:flutter/material.dart';
import 'package:game/route/navigation_services.dart';
import 'package:game/route/routes.dart';
import 'package:game/screen/study/study_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  final String title = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Quiz Game'),
          onPressed: () {
            final topicId = '4735054791049216';
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => StudyScreen(topicId)),
            );
          },
        ),
      ),
    );
  }
}
