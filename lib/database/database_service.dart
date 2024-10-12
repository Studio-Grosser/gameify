import 'package:gameify/models/date.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/logger.dart';
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

  Future<bool> get isInitialized async => await databaseExists(dbPath);

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    try {
      await db.execute('''
      CREATE TABLE ${Habit.tableName} (
        ${Habit.id_} TEXT PRIMARY KEY,
        ${Habit.name_} TEXT NOT NULL,
        ${Habit.score_} INTEGER NOT NULL,
        ${Habit.createdAt_} TEXT NOT NULL,
        ${Habit.isActive_} INTEGER NOT NULL,
        ${Habit.mode_} TEXT NOT NULL
      )
      ''');

      Logger.s('Table "${Habit.tableName}" created');

      await db.execute('''
      CREATE TABLE ${Date.tableName} (
        ${Date.id_} TEXT PRIMARY KEY,
        ${Date.completedHabitIds_} TEXT NOT NULL,
        ${Date.score_} INTEGER
      )
      ''');

      Logger.s('Table "${Date.tableName}" created');
    } catch (e, st) {
      Logger.f('Error creating database: ${e.toString()}', st);
    }
  }

  Future<void> delteDb() async {
    try {
      await deleteDatabase(dbPath);
      Logger.s('databse deleted');
    } catch (e, st) {
      Logger.e('Error deleting database', st);
    }
  }

  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
      Logger.s('database closed');
    } catch (e, st) {
      Logger.e('Error closing database', st);
    }
  }
}
