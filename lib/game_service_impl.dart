import 'package:demo_game/route/navigation_services.dart';
import 'package:demo_game/route/routes.dart';
import 'package:game/model/core/question.dart';
import 'package:game/repository/sql_repository.dart';
import 'package:game/service/game_service.dart';
import 'package:game/utils/request.dart';
import 'package:sqflite/sqflite.dart';

class GameServiceImpl implements GameService {
  Database _db = SqfliteRepository().moduleDB;

  @override
  Future<List<Question>> loadQuestionsByParentId(
      {required String parentId}) async {
    List<Question> result = [];

    final maps = await requestApi<List<Map>, List<Map>>(
      call: () => _db.query(
        "$tableQuestion",
        where: '"parentId" = $parentId',
      ),
      defaultValue: [],
    );

    if (maps.length > 0) {
      for (var item in maps) {
        Question question = Question.fromJson(item as Map<String, dynamic>);
        result.add(question);
      }
    }
    if (result.length < 5) {
      return result;
    } else {
      return result.sublist(0, 5);
    }
  }

  @override
  Future<List<Question>> loadChildQuestionList(
      Map<String, Question> mapHasChild) async {
    List<Question> results = [];
    String sql = '''
    select *
    from $tableQuestion as q
    where q.parentId in (
    ''';
    mapHasChild.forEach((String key, Question question) {
      sql += '$key,';
    });
    sql = sql.substring(0, sql.length - 1);
    sql += ')';
    List<Map<String, dynamic>> maps = await requestApi<
        List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      call: () => _db.rawQuery(sql),
      defaultValue: [],
    );
    if (maps.length > 0) {
      maps.forEach((element) {
        Question question = Question.fromJson(element);
        question.parentQues = mapHasChild[question.parentId!];
        double parentOrderIndex = mapHasChild[question.parentId!]!.orderIndex!;
        if (parentOrderIndex < 0) {
          parentOrderIndex = 0;
        }
        question.orderIndex =
            parentOrderIndex + (parentOrderIndex + question.orderIndex!) / 100;
        // print(parentOrderIndex);
        results.add(question);
      });
    }

    return results;
  }

  @override
  navigateAfterFinishingStudy() {
    NavigationService().pushNamedAndRemoveUntil(
        ROUTE_AFTER_STUDY, (route) => route.settings.name == ROUTE_BEFORE_HOME);
  }
}
