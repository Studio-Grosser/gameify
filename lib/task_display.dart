import 'package:flutter/material.dart';
import 'package:gameify/task.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay(
      {super.key,
      required this.task,
      required this.isCompleted,
      required this.onChanged});
  final Task task;
  final bool isCompleted;
  final Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: isCompleted,
            onChanged: (value) => onChanged(value ?? false)),
        Text(task.name),
        Text(task.score.toString()),
      ],
    );
  }
}
