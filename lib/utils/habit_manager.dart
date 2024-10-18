import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/utils.dart';
import 'package:collection/collection.dart';

class HabitManager extends ChangeNotifier {
  HabitManager() {
    loadHabits();
    loadAllDates();
  }

  DateTime currentDate = DateTime.now().startOfDay;
  Map<String, int> _completedHabitIds = {};
  int highscore = 0;
  int average = 0;
  List<Date>? allDates;
  Filter currentFilter = Filter.all;

  List<Habit> _rawHabits = [];

  List<Habit> get habits => _rawHabits
      .where((habit) => habit.isActive || (getHabitValue(habit.id) ?? 0) > 0)
      .toList();

  List<Habit> get filteredHabits {
    switch (currentFilter) {
      case Filter.positives:
        return habits.where((habit) => habit.score > 0).toList();
      case Filter.negatives:
        return habits.where((habit) => habit.score < 0).toList();
      default:
        return habits;
    }
  }

  int get score => positiveScore + negativeScore;
  int get positiveScore => _calculateScore((habit) => habit.score >= 0);
  int get negativeScore => _calculateScore((habit) => habit.score < 0);

  int _calculateScore(bool Function(Habit) condition) {
    return habits.where(condition).fold(
        0, (sum, habit) => sum + habit.score * (getHabitValue(habit.id) ?? 0));
  }

  int? getHabitValue(String id) => _completedHabitIds[id];

  Future<void> changeDate(DateTime date) async {
    currentDate = date;
    await _loadDate();
  }

  Future<void> onHabitTap(Habit habit) async {
    _completedHabitIds.update(habit.id, (value) => habit.updateAlgorithm(value),
        ifAbsent: () => 1);
    _updateOrAddDate();
    await _writeCurrentDate();
    notifyListeners();
  }

  Future<void> onHabitDelete(BuildContext context, Habit habit,
      {bool confirm = true}) async {
    if (!confirm || await confirmDelete(context, habit)) {
      await Habitservice().updateActiveState(habit.id, false);
      habit.toggleActive();
      notifyListeners();
    }
  }

  void _updateOrAddDate() {
    final newDate = Date(
      id: currentDate.toId(),
      completedHabitIds: _completedHabitIds,
      score: score,
    );
    final index = allDates?.indexWhere((d) => d.id == newDate.id) ?? -1;
    if (index == -1) {
      allDates?.add(newDate);
    } else {
      allDates?[index] = newDate;
    }
  }

  Future<void> _writeCurrentDate() async {
    await DateService().writeDate(Date(
      id: currentDate.toId(),
      completedHabitIds: _completedHabitIds,
      score: score,
    ));
    _refreshMetrics();
  }

  Future<void> _refreshMetrics() async {
    final scores = allDates?.map((date) => date.score) ?? const [];
    if (scores.isEmpty) return;
    final sum = scores.reduce((a, b) => a + b);
    highscore =
        scores.reduce((current, next) => current > next ? current : next);
    average = sum ~/ scores.length;
    notifyListeners();
  }

  Future<void> resetHabit(String habitId) async {
    _completedHabitIds.remove(habitId);
    _updateOrAddDate();
    await _writeCurrentDate();
  }

  Future<void> loadHabits() async {
    final habits = await Habitservice().readHabits();
    _rawHabits = habits;
    sortHabits();
    notifyListeners();
  }

  Future<void> loadAllDates() async {
    final dates = await DateService().readAllDates();
    allDates = dates;
    await _loadDate();
  }

  Future<void> _loadDate() async {
    Date? date =
        allDates?.firstWhereOrNull((date) => date.id == currentDate.toId());
    _completedHabitIds = date?.completedHabitIds ?? {};
    _refreshMetrics();
    notifyListeners();
  }

  void sortHabits() {
    _rawHabits.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void changeFilter(Filter newFilter) {
    currentFilter = newFilter;
    notifyListeners();
  }
}
