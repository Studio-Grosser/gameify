import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/custom_checkbox.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';

class HabitDisplay extends StatefulWidget {
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

  @override
  State<HabitDisplay> createState() => _HabitDisplayState();
}

class _HabitDisplayState extends State<HabitDisplay> {
  bool get showOptions => widget.onDelete != null || widget.onEdit != null;
  bool get isTappable => widget.onTap != null || widget.value != null;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Opacity(
        opacity: widget.habit.isActive ? 1 : 0.75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Slidable(
            enabled: showOptions,
            key: UniqueKey(),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => widget.onEdit!(),
                  backgroundColor: Themes.accent,
                  foregroundColor: Themes.shade1,
                  label: 'Edit',
                  icon: CupertinoIcons.square_pencil,
                ),
                SlidableAction(
                  onPressed: (_) => widget.onDelete!(),
                  backgroundColor: Themes.danger,
                  foregroundColor: Themes.shade1,
                  label: 'Delete',
                  icon: CupertinoIcons.trash,
                ),
              ],
            ),
            child: GestureDetector(
              onTap: isTappable ? () => widget.onTap!() : null,
              onLongPress: isTappable ? () => widget.onReset!() : null,
              child: StyledContainer(
                hideBorder: true,
                margin: const EdgeInsets.symmetric(vertical: 0),
                borderRadius: 0,
                child: Row(
                  children: [
                    if (isTappable) ...[
                      CustomCheckbox(
                          onTap: () => widget.onTap!(),
                          mode: widget.habit.mode,
                          value: widget.value),
                    ],
                    const Gap(10),
                    Expanded(
                        child: Text(widget.habit.name,
                            style: theme.textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1)),
                    ValueDisplay(value: widget.habit.score),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
