import 'package:flutter/material.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/task_option_menu.dart';
import 'package:gameify/widgets/value_display.dart';

class TaskDisplay extends StatelessWidget {
  const TaskDisplay(
      {super.key,
      required this.task,
      required this.isCompleted,
      required this.onChanged,
      this.onDelete,
      this.onEdit});
  final Task task;
  final bool isCompleted;
  final Function(bool value) onChanged;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  bool get hasOptions => onDelete != null || onEdit != null;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: task.isActive ? 1 : 0.75,
      child: GestureDetector(
        onTap: () => onChanged(!isCompleted),
        child: StyledContainer(
          hideBorder: true,
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Checkbox(
                  activeColor: Themes.primary,
                  visualDensity: VisualDensity.comfortable,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  side: WidgetStateBorderSide.resolveWith(
                    (states) =>
                        const BorderSide(width: 2, color: Themes.primary),
                  ),
                  value: isCompleted,
                  onChanged: (value) => onChanged(value ?? false)),
              const SizedBox(width: 10),
              Expanded(
                  child: Text(task.name,
                      style: Font.b1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1)),
              const SizedBox(width: 10),
              ValueDisplay(value: task.score),
              if (hasOptions)
                TaskOptionMenu(
                  isEnabled: task.isActive,
                  onDelete: onDelete!,
                  onEdit: onEdit!,
                )
            ],
          ),
        ),
      ),
    );
  }
}
