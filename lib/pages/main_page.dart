import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/pages/add_habit_page.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/pages/intro_page.dart';
import 'package:gameify/widgets/custom_date_picker.dart';
import 'package:gameify/widgets/filter_slider.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/no_habit_info.dart';
import 'package:gameify/widgets/settings_drawer.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';
import 'package:gameify/widgets/habit_display.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  DateTime currentDate = DateTime.now();

  Future<int?>? highscore;
  Future<double?>? average;

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

  List<Habit> rawHabits = [];
  List<Habit> get habits => rawHabits
      .where((habit) => habit.isActive || isHabitCompleted(habit.id))
      .toList();
  Set<String> completedHabitIds = {};
  bool isHabitCompleted(String id) => completedHabitIds.contains(id);

  int get score => positiveScore + negativeScore;

  int get positiveScore => habits
      .where((habit) => isHabitCompleted(habit.id) && habit.score > 0)
      .fold(0, (sum, habit) => sum + habit.score);

  int get negativeScore => habits
      .where((habit) => isHabitCompleted(habit.id) && habit.score < 0)
      .fold(0, (sum, habit) => sum + habit.score);

  void changeDate(DateTime date) {
    setState(() => currentDate = date);
    loadDate();
    loadMetrics();
  }

  Future<void> loadDate() async {
    DateService().readDate(currentDate.toId()).then((value) {
      setState(() {
        completedHabitIds = value?.completedHabitIds ?? {};
      });
    });
  }

  Future<void> onHabitChange(bool value, Habit habit) async {
    jump();
    setState(() {
      value
          ? completedHabitIds.add(habit.id)
          : completedHabitIds.remove(habit.id);
    });
    HapticFeedback.mediumImpact();
    await DateService().writeDate(Date(
      id: currentDate.toId(),
      completedHabitIds: completedHabitIds,
      score: score,
    ));
    loadMetrics();
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

    DatabaseService.instance.isInitialized.then((isInitialized) {
      if (!isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return IntroPage(
              onSubmit: (initialHabits) {
                setState(() => rawHabits = initialHabits);
                for (var habit in initialHabits) {
                  Habitservice().writeHabit(habit);
                }
              },
            );
          }));
        });
      }
    });

    loadDate();
    loadMetrics();

    Habitservice().readHabits().then((value) => setState(() {
          rawHabits = value;
          sortHabits();
        }));
  }

  void loadMetrics() {
    highscore = DateService().getHighestScore();
    average = DateService().getAverageScore();
  }

  void sortHabits() =>
      rawHabits.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void openAddHabitPage(BuildContext context, {Habit? initialHabit}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddHabitPage(
        initialHabit: initialHabit,
        onSubmit: (habit) async {
          if (initialHabit != null) {
            await onHabitDelete(initialHabit, confirm: false);
          }
          await Habitservice().writeHabit(habit);
          setState(() {
            rawHabits.add(habit);
            sortHabits();
          });
        },
      );
    }));
  }

  void showDatePicker() async {
    Map<DateTime, double> heatMapData =
        await DateService().getHeatMapData(await highscore ?? 0);
    if (!mounted) return;
    showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomDatePicker(
              onChanged: changeDate,
              selectedDate: currentDate.startOfDay,
              heatFactors: heatMapData);
        });
  }

  double _jumpScale = 1;
  final Duration _animationDuration = const Duration(milliseconds: 100);

  Future<void> jump() async {
    setState(() => _jumpScale = 1.15);
    await Future.delayed(_animationDuration);
    setState(() => _jumpScale = 1);
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
        icon: FontAwesomeIcons.plus,
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
                    icon: FontAwesomeIcons.calendar,
                    onTap: showDatePicker,
                  ),
                  StyledIcon(
                    icon: FontAwesomeIcons.bars,
                    onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                  )
                ],
              ),
              const Gap(20),
              AnimatedScale(
                scale: _jumpScale,
                duration: _animationDuration,
                curve: Curves.easeInOut,
                child: StyledContainer(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    hideBorder: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueDisplay(
                            value: negativeScore, isDefaultNegative: true),
                        Text(score.toString(),
                            style: theme.textTheme.titleLarge),
                        ValueDisplay(value: positiveScore),
                      ],
                    )),
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
                              bool isCompleted = isHabitCompleted(habit.id);
                              return HabitDisplay(
                                habit: habit,
                                isCompleted: isCompleted,
                                onChanged: (value) =>
                                    onHabitChange(value, habit),
                                onDelete: () => onHabitDelete(habit),
                                onEdit: () => openAddHabitPage(context,
                                    initialHabit: habit),
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
