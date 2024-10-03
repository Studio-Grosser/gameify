import 'dart:developer';

import 'package:gameify/models/date.dart';
import 'package:gameify/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  static const dbPath = 'gameify.db';

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(dbPath);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${Task.tableName} (
        ${Task.id_} TEXT PRIMARY KEY,
        ${Task.name_} TEXT NOT NULL,
        ${Task.score_} INTEGER NOT NULL
      )
      ''');

    await db.execute('''
      CREATE TABLE ${Date.tableName} (
        ${Date.id_} TEXT PRIMARY KEY,
        ${Date.completedTaskIds_} TEXT NOT NULL,
        ${Date.score_} INTEGER
      )
      ''');
  }

  Future<void> delteDb() async {
    await deleteDatabase(dbPath);
    log('database deleted');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
    log('database closed');
  }
}
