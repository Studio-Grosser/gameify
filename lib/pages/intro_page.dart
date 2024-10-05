import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/task_display.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key, required this.onSubmit});
  final Function(List<Task>) onSubmit;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static final List<Task> tasks = [
    Task(name: 'Go to the gym', score: 20),
    Task(name: 'Read 10 pages', score: 5),
    Task(name: 'Take a 30 minute walk', score: 10),
    Task(name: 'Watch Netflix', score: -5),
    Task(name: 'Eat fast food', score: -10),
  ];

  List<String> taskIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StyledFab(
        padding: const EdgeInsets.all(0),
        height: 70,
        width: 70,
        icon: FontAwesomeIcons.chevronRight,
        onTap: () {
          widget.onSubmit(
              tasks.where((task) => taskIds.contains(task.id)).toList());
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('choose your first tasks', style: Font.h3),
            const SizedBox(height: 60),
            ...tasks.map((task) => TaskDisplay(
                  task: task,
                  isCompleted: taskIds.contains(task.id),
                  onChanged: (value) => setState(() =>
                      value ? taskIds.add(task.id) : taskIds.remove(task.id)),
                ))
          ],
        ),
      ),
    );
  }
}
