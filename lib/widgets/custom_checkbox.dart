import 'package:flutter/material.dart';
import 'package:gameify/models/habit_mode.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox(
      {super.key,
      required this.onTap,
      required this.mode,
      required this.value});
  final VoidCallback onTap;
  final HabitMode mode;
  final int? value;

  String get valueText {
    if (value == null || value == 0) {
      return '';
    } else {
      return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (mode == HabitMode.checkbox) {
      return Checkbox(value: (value ?? 0) > 0, onChanged: (_) => onTap());
    }
    return Container(
      width: 22,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: (value ?? 0) > 0 ? theme.checkboxTheme.side?.color : null,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(width: 2, color: theme.checkboxTheme.side!.color)),
      child: Center(
        child: Text(
          valueText,
          style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primaryContainer,
              height: 1,
              fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
