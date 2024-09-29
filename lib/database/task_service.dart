import 'package:gameify/database/database_service.dart';
import 'package:gameify/task.dart';

class TaskService {
  Future<List<Task>> readTasks() async {
    final db = await DatabaseService.instance.database;
    final tasks = await db.query(Task.tableName);
    return tasks.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> writeTask(Task task) async {
    final db = await DatabaseService.instance.database;
    await db.insert(Task.tableName, task.toJson());
  }

  Future<void> createTask(Task task) async {
    final db = await DatabaseService.instance.database;
    await db.insert(Task.tableName, task.toJson());
  }
}
