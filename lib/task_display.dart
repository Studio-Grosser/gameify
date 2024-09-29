import 'package:flutter/material.dart';
import 'package:gameify/task.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(task.name),
        Text(task.score.toString()),
      ],
    );
  }
}
