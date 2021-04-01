import 'dart:convert';

import 'package:game/model/core/choice.dart';
import 'package:game/utils/constant.dart';
import 'package:game/utils/utils.dart';

final String tableQuestion = "Question";
final String _columnId = "id";
final String _columnParentId = "parentId";
final String _columnImage = 'image';
final String _columnSound = 'sound';
final String _columnHint = 'hint';
final String _columnExplain = 'explain';
final String _columnContent = 'content';
final String _columnVideo = "video";
final String _columnCorrectAnswers = "correctAnswers";
final String _columnChoices = "choices";
final String _orderIndex = "orderIndex";
final String _columnType = "type";
final String _columnSkill = "skill";
final String _columnBackSound = "backSound";
final String createQuestionTable = '''
        create table IF NOT EXISTS $tableQuestion (
          $_columnId text primary key,
          $_columnParentId text not null,
          $_columnContent text not null,
          $_columnSound text,
          $_columnBackSound text,
          $_columnType integer,
          $_orderIndex integer,
          $_columnSkill integer,
          $_columnImage text,
          $_columnVideo text,
          $_columnHint text,
          $_columnCorrectAnswers text,
          $_columnChoices text,
          $_columnExplain text)
        ''';

enum QuestionStatus {
  delete,
  notAnswerYet ,
  answeredIncorrect,
  answeredCorrect
}


class Question {
  String? id;
  String? parentId;
  String? content;
  String? hint;
  String? explain;
  List<Choice>? choices;
  String? image;
  int? type;
  int? skill;
  String? sound;
  String? backSound;
  bool hasChild = false;
  QuestionStatus questionStatus = QuestionStatus.notAnswerYet;
  List<Question> children = [];
  bool? isChildQues = false;
  Question? parentQues;
  double? orderIndex;

  Question({this.id,
    this.content,
    this.hint,
    this.explain,
    this.type,
    this.isChildQues,
    this.parentQues,
    this.skill,
    this.orderIndex,
    this.choices,
    this.sound,
    this.backSound,
    this.parentId,
    // this.progress,
    this.image});

  Question.fromJson(Map<String, dynamic> map) {
    getInfoQues(map);
    switch (type) {
      case TYPE_CARD_NORMAL:
        getNormalQuestion(map);
        break;
      case TYPE_CARD_PARAGRAP:
        hasChild = true;
        break;
      case TYPE_CARD_PARAGRAP_CHILD:
        isChildQues = true;
        getNormalQuestion(map);
        break;
      default:
    }
  }

  getInfoQues(Map<String, dynamic> map) {
    id = map[_columnId]?.toString() ?? "-1";
    parentId = map[_columnParentId]?.toString() ?? "-1";
    content = map[_columnContent] ?? "";
    choices = [];
    type = map[_columnType] ?? TYPE_CARD_NORMAL;
    image = map[_columnImage] ?? "";
    sound = ClientUtils.checkUrl(map[_columnSound]) ?? "";
    backSound = ClientUtils.checkUrl(map[_columnBackSound]) ?? "";
    hint = map[_columnHint] ?? "";
    explain = map[_columnExplain] ?? "";
    hint = map[_columnHint] ?? "";
    skill = map[_columnSkill] ?? -1;

    orderIndex = double.parse(map[_orderIndex]?.toString() ?? "0");

    if (orderIndex! < 0) orderIndex = 0;
  }

  getNormalQuestion(Map<String, dynamic> map) {
    List<dynamic>? correctAnswer = [];
    List<dynamic>? inCorrectAnswer = [];
    if (map[_columnCorrectAnswers] != null &&
        map[_columnCorrectAnswers] != "") {
      correctAnswer = json.decode(map[_columnCorrectAnswers]);
    }
    if (map[_columnChoices] != null && map[_columnChoices] != "") {
      inCorrectAnswer = json.decode(map[_columnChoices]);
    }
    int index = 0;
    for (var i = 0; i < correctAnswer!.length; i++) {
      String choiceContent = correctAnswer[i].toString();
      Choice correctChoice = Choice(
          id: index.toString(),
          content: choiceContent,
          parentId: id!,
          isCorrect: true);
      choices!.add(correctChoice);
      index++;
    }
    for (var i = 0; i < inCorrectAnswer!.length; i++) {
      String choiceContent = inCorrectAnswer[i].toString();
      Choice correctChoice = Choice(
          id: index.toString(),
          content: choiceContent,
          parentId: id!,
          isCorrect: false);
      choices!.add(correctChoice);
      index++;
    }
    choices!.sort((a, b) => a.content.compareTo(b.content));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      _columnContent: content,
      _columnParentId: parentId,
      _columnExplain: explain,
      _columnSkill: skill,
      _columnSound: sound,
      _columnType: type,
      _columnHint: hint,
    };
  }
}