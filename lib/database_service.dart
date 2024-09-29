import 'package:gameify/task.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('gameify.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    return await openDatabase(filePath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    print('db created');
    await db.execute('''
      CREATE TABLE ${Task.tableName} (
        ${Task.id_} TEXT PRIMARY KEY,
        ${Task.name_} TEXT NOT NULL,
        ${Task.score_} INTEGER NOT NULL
      )
      ''');
  }

  Future<List<Task>> readTasks() async {
    final db = await instance.database;
    final tasks = await db.query(Task.tableName);
    return tasks.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> writeTask(Task task) async {
    final db = await instance.database;
    await db.insert(Task.tableName, task.toJson());
  }

  Future<void> createTask(Task task) async {
    final db = await instance.database;
    await db.insert(Task.tableName, task.toJson());
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
