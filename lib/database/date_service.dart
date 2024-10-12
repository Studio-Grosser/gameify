import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/utils/logger.dart';
import 'package:gameify/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DateService {
  Future<Date?> readDate(String id) async {
    final db = await DatabaseService.instance.database;

    try {
      final dates = await db.query(
        Date.tableName,
        columns: [Date.id_, Date.completedHabitIds_],
        where: '${Date.id_} = ?',
        whereArgs: [id],
      );
      Logger.s('Queried Date "$id" from database');
      if (dates.isEmpty) return null;
      return Date.fromJson(dates.first);
    } catch (e, st) {
      Logger.e('Error querying date "$id": ${e.toString()}', st);
      return null;
    }
  }

  Future<void> writeDate(Date date) async {
    final db = await DatabaseService.instance.database;

    try {
      await db.insert(Date.tableName, date.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      Logger.s('Date "${fromId(date.id)}" added to database');
    } catch (e, st) {
      Logger.e('Error inserting date: ${e.toString()}', st);
    }
  }

  Future<int> getHighestScore() async {
    final db = await DatabaseService.instance.database;

    try {
      final List<Map<String, dynamic>> result = await db
          .rawQuery('SELECT MAX(score) as max_score FROM ${Date.tableName}');
      Logger.s('Queried highest score from database');
      if (result.isNotEmpty && result.first['max_score'] != null) {
        int maxScore = result.first['max_score'] as int;
        Logger.i('Highest score is $maxScore');
        return maxScore;
      }
    } catch (e, st) {
      Logger.e('Error getting highest score: ${e.toString()}', st);
    }
    return 0;
  }

  Future<double> getAverageScore() async {
    final db = await DatabaseService.instance.database;

    try {
      final List<Map<String, dynamic>> result = await db
          .rawQuery('SELECT AVG(score) as avg_score FROM ${Date.tableName}');

      if (result.isNotEmpty && result.first['avg_score'] != null) {
        double averageScore = result.first['avg_score'] as double;
        Logger.i('Average score is $averageScore');
        return averageScore;
      }
    } catch (e, st) {
      Logger.e('Error getting average score: ${e.toString()}', st);
    }
    return 0;
  }

  Future<Map<DateTime, double>> getHeatMapData(int highscore) async {
    final db = await DatabaseService.instance.database;

    try {
      final List<Map<String, dynamic>> results = await db.query(Date.tableName);

      Map<DateTime, double> scoreMap = {};

      for (var row in results) {
        String id = row[Date.id_];
        int score = row[Date.score_] ?? 0;

        DateTime dateTime = fromId(id);
        double relativeScore = highscore > 0 ? score / highscore : 0.0;

        scoreMap[dateTime] = relativeScore;
      }
      Logger.s('Queried heat map data from database');
      return scoreMap;
    } catch (e, st) {
      Logger.e('Error getting average score: ${e.toString()}', st);
      return {};
    }
  }
}
