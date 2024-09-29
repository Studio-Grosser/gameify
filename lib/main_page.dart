import 'package:flutter/material.dart';
import 'package:gameify/task.dart';
import 'package:gameify/task_display.dart';

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

  List<Task> tasks = [
    Task(name: 'name', score: 20),
    Task(name: 'nasdassame', score: -15)
  ];
  Set<String> completedTasks = {};

  void changeDay(int offset) {
    setState(() {
      currentDate = currentDate.add(Duration(days: offset));
    });
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => changeDay(-1),
                    icon: Icon(Icons.chevron_left)),
                Text(currentDate.toString()),
                IconButton(
                    onPressed: () => changeDay(1),
                    icon: Icon(Icons.chevron_right)),
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
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
