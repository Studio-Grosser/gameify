import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/utils/logger.dart';
import 'package:gameify/utils/utils.dart';
import 'package:sqflite/sqflite.dart';

class DateService {
  Future<Date?> readDate(String id) async {
    final db = await DatabaseService.instance.database;

    try {
      final date = await db.query(
        Date.tableName,
        columns: [Date.id_, Date.completedHabitIds_, Date.score_],
        where: '${Date.id_} = ?',
        whereArgs: [id],
      );
      Logger.s('Queried Date "$id" from database');
      if (date.isEmpty) return null;
      return Date.fromJson(date.first);
    } catch (e, st) {
      Logger.e('Error querying date "$id": ${e.toString()}', st);
      return null;
    }
  }

  Future<List<Date>?> readAllDates() async {
    final db = await DatabaseService.instance.database;

    try {
      final dates = await db.query(Date.tableName,
          columns: [Date.id_, Date.completedHabitIds_, Date.score_]);
      Logger.s('Queried all Dates from database');
      if (dates.isEmpty) return null;
      return dates.map((date) => Date.fromJson(date)).toList();
    } catch (e, st) {
      Logger.e('Error querying all dates: ${e.toString()}', st);
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
}
