import 'package:uuid/uuid.dart';

final String tableChoice = 'Choice';
final String _columnId = 'id';
final String _columnParentId = 'parentId';
final String _columnSelected = 'selected';
final String _columnTestId = 'testId';
final String _columnContent = 'content';
final String _columnIsCorrect = 'isCorrect';

final String createChoiceTable = '''
        create table IF NOT EXISTS $tableChoice (
          $_columnId text primary key,
          $_columnParentId text,
          $_columnSelected boolean,
          $_columnIsCorrect boolean,
          // $_columnTestId text,
          $_columnContent text not null)
        ''';

class Choice {
  String? id;
  String parentId;

  // String testId;
  bool isCorrect;
  bool selected = false;
  String content;

  Choice(
      {this.id,
      required this.parentId,
      required this.content,
      required this.isCorrect});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      _columnContent: content,
      _columnIsCorrect: isCorrect ? 1 : 0,
      _columnSelected: selected ? 1 : 0,
      _columnParentId: parentId
    };
    if (id != null) {
      map[_columnId] = id;
    }
    return map;
  }

  factory Choice.fromMap(Map<String, dynamic> map, {int? questionId}) {
    Choice choice = Choice(
        parentId: map[_columnParentId],
        content: map[_columnContent],
        isCorrect: (map[_columnIsCorrect] == 1) ? true : false);
    choice.id = map[_columnId];
    choice.selected = (map[_columnSelected] == 1) ? true : false;

    // content = map[_columnContent];
    // id = map[_columnId];
    // parentId = map[_columnParentId] ?? "";
    // // testId = map[_columnTestId] ?? "";
    // isCorrect = (map[_columnIsCorrect] == 1) ? true : false;
    // selected = (map[_columnSelected] == 1) ? true : false;
    return choice;
  }

  factory Choice.copyWith(Choice clone) {
    Choice choice = Choice(
        id: clone.id,
        parentId: clone.parentId,
        content: clone.content,
        isCorrect: clone.isCorrect);
    // id = clone.id;
    // isCorrect = clone.isCorrect;
    // parentId = clone.parentId;
    // content = clone.content;
    return choice;
  }

  factory Choice.cloneWrongChoice(Choice clone) {
    // id = Uuid().v1();
    // isCorrect = false;
    // parentId = clone.parentId;
    // content = clone.content;
    // selected = false;
    return Choice(
      id: Uuid().v1(),
      parentId: clone.parentId,
      content: clone.content,
      isCorrect: false,
    )..selected = false;
  }

  @override
  String toString() {
    return "choice: { id: $id, parentId: $parentId, isCorrect $isCorrect, content: $content }";
  }

  reset() {
    selected = false;
  }
}
