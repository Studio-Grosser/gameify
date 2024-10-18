import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/confirm_dialog.dart';
import 'package:gameify/widgets/habit/habit_dummy.dart';

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
