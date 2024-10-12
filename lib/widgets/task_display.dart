import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/habit_option_menu.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';

class HabitDisplay extends StatelessWidget {
  const HabitDisplay(
      {super.key,
      required this.habit,
      this.isCompleted,
      this.onChanged,
      this.onDelete,
      this.onEdit});
  final Habit habit;
  final bool? isCompleted;
  final Function(bool value)? onChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  bool get hasOptions => onDelete != null || onEdit != null;
  bool get isTappable => onChanged != null || isCompleted != null;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Opacity(
      opacity: habit.isActive ? 1 : 0.75,
      child: GestureDetector(
        onTap: isTappable ? () => onChanged!(!isCompleted!) : null,
        child: StyledContainer(
          hideBorder: true,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              if (isTappable)
                Checkbox(
                    value: isCompleted,
                    onChanged: (value) => onChanged!(value ?? false)),
              const Gap(10),
              Expanded(
                  child: Text(habit.name,
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)),
              const Gap(10),
              ValueDisplay(value: habit.score),
              if (hasOptions)
                HabitOptionMenu(
                  isEnabled: habit.isActive,
                  onDelete: onDelete!,
                  onEdit: onEdit!,
                  onReset: () => onChanged!(false),
                )
            ],
          ),
        ),
      ),
    );
  }
}
