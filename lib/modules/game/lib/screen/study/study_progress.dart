// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/percent_indicator.dart';

class StudyProgressWidget extends StatelessWidget {
  final int correct;
  final int total;
  StudyProgressWidget({required this.correct, required this.total});
  @override
  Widget build(BuildContext context) {
    double percent = correct / total;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 5, bottom: 15, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  'Progress : ($correct / $total)',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ),
          Container(
            child: LinearPercentIndicator(
              lineHeight: 8.0,
              percent: percent,
              progressColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
