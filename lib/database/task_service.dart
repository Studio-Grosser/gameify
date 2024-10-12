import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/logger.dart';

class TaskService {
  Future<List<Task>> readTasks() async {
    final db = await DatabaseService.instance.database;
    final tasks = await db.query(Task.tableName);
    return tasks.map((task) => Task.fromJson(task)).toList();
  }

  Future<void> writeTask(Task task) async {
    final db = await DatabaseService.instance.database;
    await db.insert(Task.tableName, task.toJson());
    Logger.s('Task "${task.name}" added to db');
  }

  Future<void> updateActiveState(String taskId, bool isActive) async {
    final db = await DatabaseService.instance.database;
    await db.update(Task.tableName, {Task.isActive_: isActive ? 1 : 0});
    Logger.s('Task "$taskId" changed isActive status to "$isActive"');
  }
}
