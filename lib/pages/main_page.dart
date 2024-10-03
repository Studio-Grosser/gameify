import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/pages/add_task_page.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/database/date_service.dart';
import 'package:gameify/database/task_service.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/task_display.dart';
import 'package:gameify/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StyledFab(
        icon: FontAwesomeIcons.plus,
        width: 65,
        height: 65,
        onTap: () {
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
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              IconButton(
                  onPressed: () => DatabaseService.instance.delteDb(),
                  icon: Icon(Icons.delete)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => changeDay(-1),
                      icon: const Icon(Icons.chevron_left)),
                  Text(currentDate.toString()),
                  IconButton(
                      onPressed: () => changeDay(1),
                      icon: const Icon(Icons.chevron_right)),
                ],
              ),
              Text(score.toString()),
              SizedBox(
                height: 300,
                child: ListView.builder(
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
