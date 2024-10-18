import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/filter_slider.dart';
import 'package:gameify/widgets/heat_map/heat_map.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/no_habit_info.dart';
import 'package:gameify/widgets/score_display.dart';
import 'package:gameify/widgets/settings_drawer.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';
import 'package:gameify/widgets/habit_display.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  DateTime currentDate = DateTime.now().startOfDay;
  Map<String, int> completedHabitIds = {};

  int highscore = 0;
  int average = 0;
  List<Date>? allDates;

  Filter currentFilter = Filter.all;

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

  int get positiveScore => habits.where((habit) => habit.score >= 0).fold(
      0, (sum, habit) => sum + habit.score * (getHabitValue(habit.id) ?? 0));

  int get negativeScore => habits.where((habit) => habit.score < 0).fold(
      0, (sum, habit) => sum + habit.score * (getHabitValue(habit.id) ?? 0));

  List<Habit> rawHabits = [];
  List<Habit> get habits => rawHabits
      .where((habit) => habit.isActive || (getHabitValue(habit.id) ?? 0) > 0)
      .toList();

  int? getHabitValue(String id) {
    if (completedHabitIds.containsKey(id)) {
      return completedHabitIds[id];
    }
    return null;
  }

  void changeDate(DateTime date) {
    setState(() => currentDate = date);
    loadDate();
  }

  void resetHabit(String habitId) async {
    setState(() {
      if (completedHabitIds.containsKey(habitId)) {
        completedHabitIds.remove(habitId);
      }
    });
    await DateService().writeDate(Date(
      id: currentDate.toId(),
      completedHabitIds: completedHabitIds,
      score: score,
    ));
    refreshMetrics();
  }

  Future<void> loadDate() async {
    Date? date = allDates?.firstWhereOrNull((d) => d.id == currentDate.toId());
    setState(() {
      completedHabitIds = date?.completedHabitIds ?? {};
    });
    refreshMetrics();
  }

  Future<void> onHabitTap(Habit habit) async {
    setState(() {
      completedHabitIds.update(
          habit.id, (value) => habit.updateAlgorithm(value),
          ifAbsent: () => 1);

      Date newDate = Date(
        id: currentDate.toId(),
        completedHabitIds: completedHabitIds,
        score: score,
      );

      int index = allDates?.indexWhere((d) => d.id == newDate.id) ?? -1;
      if (index == -1) {
        allDates?.add(newDate);
      } else {
        allDates?[index] = newDate;
      }
    });
    HapticFeedback.mediumImpact();
    await DateService().writeDate(Date(
      id: currentDate.toId(),
      completedHabitIds: completedHabitIds,
      score: score,
    ));
    refreshMetrics();
  }

  Future<void> onHabitDelete(Habit habit, {bool confirm = true}) async {
    bool confirmed = !confirm ? true : await confirmDelete(context, habit);
    if (!confirmed) return;
    await Habitservice().updateActiveState(habit.id, false);
    setState(() => habit.toggleActive());
  }

  @override
  void initState() {
    super.initState();

    Habitservice().readHabits().then((value) => setState(() {
          rawHabits = value;
          sortHabits();
        }));

    DateService().readAllDates().then((value) => setState(() {
          allDates = value;
          loadDate();
        }));
  }

  Future<void> refreshMetrics() async {
    final scores = allDates?.map((date) => date.score) ?? const [];
    final sum = scores.reduce((a, b) => a + b);

    setState(() {
      highscore =
          scores.reduce((current, next) => current > next ? current : next);
      average = scores.isNotEmpty ? sum ~/ scores.length : 0;
    });
  }

  void sortHabits() =>
      rawHabits.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void openAddHabitPage(BuildContext context, {Habit? initialHabit}) {
    void onSubmit(Habit habit) async {
      if (initialHabit != null) {
        await onHabitDelete(initialHabit, confirm: false);
      }
      await Habitservice().writeHabit(habit);
      setState(() {
        rawHabits.add(habit);
        sortHabits();
      });
    }

    context.go('/main/addHabit', extra: [onSubmit, initialHabit]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: StyledFab(
        padding: EdgeInsets.zero,
        height: 70,
        width: 70,
        icon: CupertinoIcons.plus,
        onTap: () => openAddHabitPage(context),
      ),
      endDrawer: const SettingsDrawer(),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(currentDate.format(),
                      style: theme.textTheme.titleMedium),
                  const Spacer(),
                  StyledIcon(
                    icon: CupertinoIcons.calendar,
                    onTap: () => showCalendar(
                        context: context,
                        currentDate: currentDate,
                        changeDate: changeDate),
                  ),
                  StyledIcon(
                    icon: CupertinoIcons.settings,
                    onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                  )
                ],
              ),
              const Gap(20),
              ScoreDisplay(
                score: score,
                negativeScore: negativeScore,
                positiveScore: positiveScore,
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  children: [
                    Row(
                      children: [
                        MetricDisplay(metric: average, unit: 'average'),
                        MetricDisplay(metric: highscore, unit: 'highscore'),
                      ],
                    ),
                    HeatMap(dates: allDates ?? [], currentDate: currentDate),
                    const Gap(100),
                    FilterSlider(
                        currentFilter: currentFilter,
                        onChanged: (newFilter) {
                          setState(() {
                            currentFilter = newFilter ?? Filter.all;
                          });
                        }),
                    const Gap(10),
                    filteredHabits.isEmpty
                        ? const NoHabitInfo()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 100),
                            shrinkWrap: true,
                            itemCount: filteredHabits.length,
                            itemBuilder: (context, index) {
                              Habit habit = filteredHabits[index];
                              int? value = getHabitValue(habit.id);
                              return HabitDisplay(
                                habit: habit,
                                value: value,
                                onTap: () => onHabitTap(habit),
                                onDelete: () => onHabitDelete(habit),
                                onEdit: () => openAddHabitPage(context,
                                    initialHabit: habit),
                                onReset: () => resetHabit(habit.id),
                              );
                            }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
