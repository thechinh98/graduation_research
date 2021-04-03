import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/model/core/question.dart';
import 'package:game/utils/request.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class SqfliteRepository {
  factory SqfliteRepository() {
    if (_instance == null) {
      _instance = SqfliteRepository._getInstance();
    }
    return _instance!;
  }

  static SqfliteRepository? _instance;

  SqfliteRepository._getInstance();

  static const DB_VERSION = 1;
  Database? _db;
  String appDbName = 'data-$DB_VERSION.db';
  String dataDbName = 'data.db';
  String userDbName = 'user_data.db';
  
  Database get moduleDB  => _db!;

  Future initDb() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _checkAndCopyDatabase();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, appDbName);
    _db = await openDatabase(path);

    await _createTable(_db);
    return _db;
  }

  _checkAndCopyDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = documentsDirectory.listSync();
    for (var file in files) {
      String fileName = file.path.split('/').last;
      if (fileName.endsWith('.db') &&
          fileName.startsWith('data') &&
          !fileName.startsWith('data-$DB_VERSION.db')) {
        file.deleteSync(recursive: true);
      }
    }
    String path = join(documentsDirectory.path, appDbName);
    print("pathxxx: $path");
    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound) {
      // Load database from asset and copy
      print(
          "dbName not found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
      ByteData data;
      try {
        data = await rootBundle
            .load(join('packages/game/assets/data/', dataDbName));
      } catch (e) {
        data = await rootBundle.load(join('assets/data/', dataDbName));
      }
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
      print(
          "dbName $appDbName copy successs documentsDirectory.path: ${documentsDirectory.path}");
    } else {
      print(
          "dbName found $appDbName documentsDirectory.path: ${documentsDirectory.path}");
    }
  }

  Future _createTable(db) async {
    await db.transaction((txn) async {
      await txn.execute(createQuestionTable);
    });
  }

  /*Future<List<Question>> loadQuestionsByParentId(
      {required String parentId}) async {
    List<Question> result = [];

    final maps = await requestApi<List<Map>, List<Map>>(
      call: () => _db!.query(
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
    return result;
  }

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
    List<Map<String, dynamic>> maps = await requestApi<List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      call: () => _db!.rawQuery(sql),
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
  }*/
}
