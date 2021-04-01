import 'package:flutter/material.dart';

class AfterStudyScreen extends StatefulWidget {
  AfterStudyScreen({Key? key}) : super(key: key);

  @override
  _AfterStudyScreenState createState() => _AfterStudyScreenState();
}

class _AfterStudyScreenState extends State<AfterStudyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('After Study'),
      ),
      body: Center(
        child: Text('After Study ahihi !!!!!!!!!!'),
      ),
    );
  }
}