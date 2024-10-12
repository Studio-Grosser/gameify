import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/logger.dart';

class TaskService {
  Future<List<Task>> readTasks() async {
    final db = await DatabaseService.instance.database;
    try {
      final tasks = await db.query(Task.tableName);
      Logger.s('Queried "${tasks.length}" Tasks from database');
      return tasks.map((task) => Task.fromJson(task)).toList();
    } catch (e, st) {
      Logger.e('Error querying tasks: ${e.toString()}', st);
      return [];
    }
  }

  Future<void> writeTask(Task task) async {
    final db = await DatabaseService.instance.database;
    try {
      await db.insert(Task.tableName, task.toJson());
      Logger.s('Task "${task.name}" added to database');
    } catch (e, st) {
      Logger.e('Error inserting task: ${e.toString()}', st);
    }
  }

  Future<void> updateActiveState(String taskId, bool isActive) async {
    final db = await DatabaseService.instance.database;
    try {
      await db.update(Task.tableName, {Task.isActive_: isActive ? 1 : 0},
          where: '${Task.id_} = ?', whereArgs: [taskId]);
      Logger.s('Task "$taskId" changed isActive status to "$isActive"');
    } catch (e, st) {
      Logger.e('Error updating task isActive status: ${e.toString()}', st);
    }
  }
}
