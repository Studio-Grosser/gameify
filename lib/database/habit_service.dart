import 'package:gameify/database/database_service.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/logger.dart';

class Habitservice {
  Future<List<Habit>> readHabits() async {
    final db = await DatabaseService.instance.database;
    try {
      final habits = await db.query(Habit.tableName);
      Logger.s('Queried "${habits.length}" Habits from database');
      return habits.map((habit) => Habit.fromJson(habit)).toList();
    } catch (e, st) {
      Logger.e('Error querying habits: ${e.toString()}', st);
      return [];
    }
  }

  Future<void> writeHabit(Habit habit) async {
    final db = await DatabaseService.instance.database;
    try {
      await db.insert(Habit.tableName, habit.toJson());
      Logger.s('Habit "${habit.name}" added to database');
    } catch (e, st) {
      Logger.e('Error inserting habit: ${e.toString()}', st);
    }
  }

  Future<void> updateActiveState(String habitId, bool isActive) async {
    final db = await DatabaseService.instance.database;
    try {
      await db.update(Habit.tableName, {Habit.isActive_: isActive ? 1 : 0},
          where: '${Habit.id_} = ?', whereArgs: [habitId]);
      Logger.s('Habit "$habitId" changed isActive status to "$isActive"');
    } catch (e, st) {
      Logger.e('Error updating habit isActive status: ${e.toString()}', st);
    }
  }
}
