import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/confirm_dialog.dart';
import 'package:gameify/widgets/habit/habit_dummy.dart';

Future<bool> confirmDelete(BuildContext context, Habit habit) async {
  return await showModalBottomSheet<bool>(
          showDragHandle: true,
          context: context,
          builder: (context) => ConfirmDialog(
                title: 'dialogs.deleteHabit.title'.tr(),
                message: 'dialogs.deleteHabit.message'.tr(),
                confirmText: 'dialogs.deleteHabit.confirm'.tr(),
                cancelText: 'dialogs.deleteHabit.cancel'.tr(),
                body: HabitDummy(habit: habit),
              )) ??
      false;
}

Future<bool> confirmReset(BuildContext context) async {
  return await showModalBottomSheet<bool>(
          showDragHandle: true,
          context: context,
          builder: (context) => ConfirmDialog(
                title: 'dialogs.resetApp.title'.tr(),
                message: 'dialogs.resetApp.message'.tr(),
                confirmText: 'dialogs.resetApp.confirm'.tr(),
                cancelText: 'dialogs.resetApp.cancel'.tr(),
              )) ??
      false;
}
