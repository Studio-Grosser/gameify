import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/pages/add_task_page.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/task_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
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

  int get score => tasks
      .where((task) =>
          completedTasks.contains(task.id)) // Nur die erledigten Tasks filtern
      .fold(0, (sum, task) => sum + task.score);

  List<Task> tasks = [];
  Set<String> completedTasks = {};

  int get positiveScore => tasks
      .where((task) => completedTasks.contains(task.id) && task.score > 0)
      .fold(0, (sum, task) => sum + task.score);

  int get negativeScore => tasks
      .where((task) => completedTasks.contains(task.id) && task.score < 0)
      .fold(0, (sum, task) => sum + task.score);

  void changeDay(int offset) {
    setState(() {
      currentDate = currentDate.add(Duration(days: offset));
    });
    loadDate();
  }

  Future<void> loadDate() async {
    DateService().readDate(currentDate.toId()).then((value) {
      setState(() {
        completedTasks = value?.completedTaskIds ?? {};
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
    loadDate();
    TaskService().readTasks().then((value) {
      setState(() {
        tasks = value;
      });
    });
  }

  void openAddTaskPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTaskPage(
        onTaskAdded: (task) async {
          await TaskService().writeTask(task);
          setState(() {
            tasks.add(task);
          });
        },
      );
    }));
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
              IconButton(
                  onPressed: () => DatabaseService.instance.delteDb(),
                  icon: const Icon(Icons.delete)),
              Text(
                currentDate.format(),
                style: Font.h2,
              ),
              const SizedBox(height: 20),
              StyledContainer(
                  padding: const EdgeInsets.all(15),
                  hideBorder: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ValueDisplay(value: positiveScore),
                      Text(
                        score.toString(),
                        style: Font.h1,
                      ),
                      ValueDisplay(
                          value: negativeScore, isDefaultNegative: true),
                    ],
                  )),
              const Row(
                children: [
                  MetricDisplay(metric: '153', unit: 'average'),
                  MetricDisplay(metric: '164', unit: 'highscore'),
                ],
              ),
              const SizedBox(height: 100),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      Task task = tasks[index];
                      bool isCompleted = completedTasks.contains(task.id);
                      return TaskDisplay(
                          task: task,
                          isCompleted: isCompleted,
                          onChanged: (value) {
                            setState(() {
                              value
                                  ? completedTasks.add(task.id)
                                  : completedTasks.remove(task.id);
                            });
                            DateService().writeDate(Date(
                                id: currentDate.toId(),
                                completedTaskIds: completedTasks));
                          });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
