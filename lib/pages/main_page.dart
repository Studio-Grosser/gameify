import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/pages/add_task_page.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/task_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/pages/intro_page.dart';
import 'package:gameify/utils/theme_provider.dart';
import 'package:gameify/widgets/custom_date_picker.dart';
import 'package:gameify/widgets/filter_slider.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/no_task_info.dart';
import 'package:gameify/widgets/settings_drawer.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';
import 'package:gameify/widgets/task_display.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

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

  List<Task> get filteredTasks {
    switch (currentFilter) {
      case Filter.positives:
        return tasks.where((task) => task.score > 0).toList();
      case Filter.negatives:
        return tasks.where((task) => task.score < 0).toList();
      default:
        return tasks;
    }
  }

  List<Task> rawTasks = [];
  List<Task> get tasks => rawTasks
      .where((task) => task.isActive || isTaskCompleted(task.id))
      .toList();
  Set<String> completedTaskIds = {};
  bool isTaskCompleted(String id) => completedTaskIds.contains(id);

  int get score => positiveScore + negativeScore;

  int get positiveScore => tasks
      .where((task) => isTaskCompleted(task.id) && task.score > 0)
      .fold(0, (sum, task) => sum + task.score);

  int get negativeScore => tasks
      .where((task) => isTaskCompleted(task.id) && task.score < 0)
      .fold(0, (sum, task) => sum + task.score);

  void changeDate(DateTime date) {
    setState(() => currentDate = date);
    loadDate();
    loadMetrics();
  }

  Future<void> loadDate() async {
    DateService().readDate(currentDate.toId()).then((value) {
      setState(() {
        completedTaskIds = value?.completedTaskIds ?? {};
      });
    });
  }

  Future<void> onTaskChange(bool value, Task task) async {
    jump();
    setState(() {
      value ? completedTaskIds.add(task.id) : completedTaskIds.remove(task.id);
    });
    HapticFeedback.mediumImpact();
    await DateService().writeDate(Date(
      id: currentDate.toId(),
      completedTaskIds: completedTaskIds,
      score: score,
    ));
    loadMetrics();
  }

  Future<void> onTaskDelete(Task task, {bool confirm = true}) async {
    bool confirmed = !confirm ? true : await confirmDelete(context, task);
    if (!confirmed) return;
    await TaskService().updateActiveState(task.id, false);
    setState(() => task.toggleActive());
  }

  @override
  void initState() {
    super.initState();

    DatabaseService.instance.isInitialized.then((isInitialized) {
      if (!isInitialized) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return IntroPage(
              onSubmit: (initialTasks) {
                setState(() => rawTasks = initialTasks);
                for (var task in initialTasks) {
                  TaskService().writeTask(task);
                }
              },
            );
          }));
        });
      }
    });

    loadDate();
    loadMetrics();

    TaskService().readTasks().then((value) => setState(() {
          rawTasks = value;
          sortTasks();
        }));
  }

  void loadMetrics() {
    highscore = DateService().getHighestScore();
    average = DateService().getAverageScore();
  }

  void sortTasks() =>
      rawTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void openAddTaskPage(BuildContext context, {Task? initialTask}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTaskPage(
        initialTask: initialTask,
        onSubmit: (task) async {
          if (initialTask != null) {
            await onTaskDelete(initialTask, confirm: false);
          }
          await TaskService().writeTask(task);
          setState(() {
            rawTasks.add(task);
            sortTasks();
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
        onTap: () => openAddTaskPage(context),
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
                    filteredTasks.isEmpty
                        ? const NoTaskInfo()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(bottom: 100),
                            shrinkWrap: true,
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              Task task = filteredTasks[index];
                              bool isCompleted = isTaskCompleted(task.id);
                              return TaskDisplay(
                                task: task,
                                isCompleted: isCompleted,
                                onChanged: (value) => onTaskChange(value, task),
                                onDelete: () => onTaskDelete(task),
                                onEdit: () =>
                                    openAddTaskPage(context, initialTask: task),
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
