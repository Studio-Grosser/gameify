import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/custom_checkbox.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/habit_option_menu.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';

class HabitDisplay extends StatelessWidget {
  const HabitDisplay(
      {super.key,
      required this.habit,
      this.value,
      this.onTap,
      this.onDelete,
      this.onEdit,
      this.onReset});
  final Habit habit;
  final int? value;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onReset;

  bool get hasOptions => onDelete != null || onEdit != null || onReset != null;
  bool get isTappable => onTap != null || value != null;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Opacity(
      opacity: habit.isActive ? 1 : 0.75,
      child: GestureDetector(
        onTap: isTappable ? () => onTap!() : null,
        onLongPress: isTappable ? () => onReset!() : null,
        child: StyledContainer(
          hideBorder: true,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              if (isTappable) ...[
                CustomCheckbox(
                    onTap: () => onTap!(), mode: habit.mode, value: value),
              ],
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
                  onReset: onReset!,
                )
            ],
          ),
        ),
      ),
    );
  }
}
