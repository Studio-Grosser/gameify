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
  int score = 0;
  List<Task> tasks = [Task(name: 'name', score: 20)];

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
                    return TaskDisplay(task: tasks[index]);
                  }),
            )
          ],
        ),
      ),
    );
  }
}
