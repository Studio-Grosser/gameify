import 'dart:async';
import 'dart:developer';

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/pages/add_task_page.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/task_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/custom_date_picker.dart';
import 'package:gameify/widgets/heat_map.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/no_task_info.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';
import 'package:gameify/widgets/task_display.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gameify/widgets/value_display.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late DateTime currentDate;

  int highscore = 0;
  double average = 0;

  int get score => tasks
      .where((task) =>
          completedTasks.contains(task.id)) // Nur die erledigten Tasks filtern
      .fold(0, (sum, task) => sum + task.score);

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
      .where((task) => task.isActive || completedTasks.contains(task.id))
      .toList();
  Set<String> completedTasks = {};

  int get positiveScore => tasks
      .where((task) => completedTasks.contains(task.id) && task.score > 0)
      .fold(0, (sum, task) => sum + task.score);

  int get negativeScore => tasks
      .where((task) => completedTasks.contains(task.id) && task.score < 0)
      .fold(0, (sum, task) => sum + task.score);

  void changeDate(DateTime date) {
    setState(() {
      currentDate = date;
    });
    loadDate();
    loadAverage();
    loadHighScore();
  }

  Future<void> loadDate() async {
    DateService().readDate(currentDate.toId()).then((value) {
      setState(() {
        completedTasks = value?.completedTaskIds ?? {};
      });
    });
  }

  Filter currentFilter = Filter.all;
  Map<Filter, String> filters = {
    Filter.all: 'all',
    Filter.positives: 'positives',
    Filter.negatives: 'negatives',
  };

  Future<void> onTaskChange(bool value, Task task) async {
    jump();
    setState(() {
      value ? completedTasks.add(task.id) : completedTasks.remove(task.id);
    });
    HapticFeedback.mediumImpact();
    await DateService().writeDate(Date(
        id: currentDate.toId(),
        completedTaskIds: completedTasks,
        score: score));

    loadAverage();
    loadHighScore();
  }

  Future<void> onTaskDelete(Task task) async {
    await TaskService().updateActiveState(task.id, false);
    setState(() {
      task.toggleActive();
    });
  }

  void onTaskEdit(Task task) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTaskPage(
        initialTask: task,
        onSubmit: (updatedTask) async {
          await onTaskDelete(task);
          await TaskService().writeTask(updatedTask);
          setState(() {
            rawTasks.add(updatedTask);
          });
        },
      );
    }));
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();

    loadDate();
    loadAverage();
    loadHighScore();

    TaskService().readTasks().then((value) {
      setState(() {
        rawTasks = value;
      });
    });
  }

  void loadHighScore() {
    DateService().getHighestScore().then((value) {
      setState(() {
        highscore = value ?? 0;
      });
    });
  }

  void loadAverage() {
    DateService().getAverageScore().then((value) {
      setState(() {
        average = value ?? 0.0;
      });
    });
  }

  void openAddTaskPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTaskPage(
        onSubmit: (task) async {
          await TaskService().writeTask(task);
          setState(() {
            rawTasks.add(task);
          });
        },
      );
    }));
  }

  void showDatePicker() async {
    Map<DateTime, double> heatMapData = await DateService().getHeatMapData();
    if (!mounted) return;
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return CustomDatePicker(
              onChanged: changeDate,
              selectedDate: currentDate,
              heatFactors: heatMapData);
        });
  }

  double _jumpScale = 1;
  final Duration _animationDuration = const Duration(milliseconds: 100);

  Future<void> jump() async {
    setState(() {
      _jumpScale = 1.15;
    });
    Timer(_animationDuration, () {
      setState(() {
        _jumpScale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StyledFab(
        padding: const EdgeInsets.all(0),
        height: 70,
        width: 70,
        icon: FontAwesomeIcons.plus,
        onTap: openAddTaskPage,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    currentDate.format(),
                    style: Font.h2,
                  ),
                  const Spacer(),
                  StyledIcon(
                    icon: FontAwesomeIcons.trashCan,
                    onTap: () => DatabaseService.instance.delteDb(),
                  ),
                  StyledIcon(
                      icon: FontAwesomeIcons.calendar, onTap: showDatePicker)
                ],
              ),
              const SizedBox(height: 20),
              AnimatedScale(
                scale: _jumpScale,
                duration: _animationDuration,
                curve: Curves.easeInOut,
                child: StyledContainer(
                    padding: const EdgeInsets.all(15),
                    hideBorder: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ValueDisplay(value: positiveScore),
                        Text(score.toString(), style: Font.h1),
                        ValueDisplay(
                            value: negativeScore, isDefaultNegative: true),
                      ],
                    )),
              ),
              Row(
                children: [
                  MetricDisplay(
                      metric: average.toStringAsFixed(2), unit: 'average'),
                  MetricDisplay(
                      metric: highscore.toString(), unit: 'highscore'),
                ],
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                child: CupertinoSlidingSegmentedControl<Filter>(
                    backgroundColor: Themes.tertiary,
                    thumbColor: Themes.surface,
                    groupValue: currentFilter,
                    children: filters.map((key, value) =>
                        MapEntry(key, Text(value, style: Font.b1.copyWith()))),
                    onValueChanged: (value) {
                      setState(() {
                        currentFilter = value ?? Filter.all;
                      });
                    }),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredTasks.isEmpty
                    ? const NoTaskInfo()
                    : FadingEdgeScrollView.fromScrollView(
                        child: ListView.builder(
                            controller: ScrollController(),
                            padding: const EdgeInsets.only(bottom: 60),
                            shrinkWrap: true,
                            itemCount: filteredTasks.length,
                            itemBuilder: (context, index) {
                              Task task = filteredTasks[index];
                              bool isCompleted =
                                  completedTasks.contains(task.id);
                              return TaskDisplay(
                                task: task,
                                isCompleted: isCompleted,
                                onChanged: (value) => onTaskChange(value, task),
                                onDelete: () => onTaskDelete(task),
                                onEdit: () => onTaskEdit(task),
                              );
                            }),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
