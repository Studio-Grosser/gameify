import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/confirm_dialog.dart';
import 'package:gameify/widgets/date_picker/custom_date_picker.dart';
import 'package:gameify/widgets/habit_dummy.dart';

enum Filter { all, positives, negatives }

enum HabitOption { edit, delete, reset }

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

  DateTime get startOfDay => DateTime(year, month, day);

  String format() {
    if (isToday) return 'today';
    return '$day/$month/$year';
  }
}

Future<bool> confirmDelete(BuildContext context, Habit habit) async {
  return await showModalBottomSheet<bool>(
          showDragHandle: true,
          context: context,
          builder: (context) => ConfirmDialog(
                title: 'Delete habit?',
                message: 'You cannot undo this action',
                confirmText: 'Delete',
                cancelText: 'Cancel',
                body: HabitDummy(habit: habit),
              )) ??
      false;
}

Future<bool> confirmReset(BuildContext context) async {
  return await showModalBottomSheet<bool>(
          showDragHandle: true,
          context: context,
          builder: (context) => const ConfirmDialog(
                title: 'Reset App?',
                message: 'You cannot undo this action',
                confirmText: 'Reset',
                cancelText: 'Cancel',
              )) ??
      false;
}

void showCalendar(
    {required BuildContext context,
    required DateTime currentDate,
    required Function(DateTime) changeDate}) async {
  if (!context.mounted) return;
  showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomDatePicker(
            onChanged: changeDate, selectedDate: currentDate.startOfDay);
      });
}
