import 'package:flutter/material.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/widgets/confirm_dialog.dart';
import 'package:gameify/widgets/task_display.dart';

enum Filter { all, positives, negatives }

enum TaskOption { edit, delete }

DateTime fromId(String id) {
  final parts = id.split('-');
  return DateTime(
      int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

extension DateExtension on DateTime {
  String toId() => '$year-$month-$day';

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String format() {
    if (isToday) return 'today';
    return '$day/$month/$year';
  }
}

Future<bool> confirmDelete(BuildContext context, Task task) async {
  return await showModalBottomSheet<bool>(
          showDragHandle: true,
          context: context,
          builder: (context) => ConfirmDialog(
                title: 'Delete task',
                message: 'You cannot undo this action',
                confirmText: 'Delete',
                cancelText: 'Cancel',
                body: TaskDisplay(
                    task: task, isCompleted: false, onChanged: (value) {}),
              )) ??
      false;
}
