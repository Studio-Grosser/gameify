import 'dart:developer';

import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/date.dart';
import 'package:sqflite/sqflite.dart';

class DateService {
  Future<Date?> readDate(String id) async {
    final db = await DatabaseService.instance.database;
    final dates = await db.query(
      Date.tableName,
      columns: [Date.id_, Date.completedTaskIds_],
      where: '${Date.id_} = ?',
      whereArgs: [id],
    );

    if (dates.isEmpty) return null;
    return Date.fromJson(dates.first);
  }

  Future<void> writeDate(Date date) async {
    final db = await DatabaseService.instance.database;
    await db.insert(Date.tableName, date.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    log('date added');
  }
}
