import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/utils/date_utils.dart';
import 'package:gameify/utils/logger.dart';
import 'package:sqflite/sqflite.dart';

class DateService {
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
}
