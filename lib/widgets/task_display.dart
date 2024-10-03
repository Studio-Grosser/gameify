import 'package:flutter/material.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/value_display.dart';

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
    return StyledContainer(
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
                (states) => const BorderSide(width: 2, color: Themes.primary),
              ),
              value: isCompleted,
              onChanged: (value) => onChanged(value ?? false)),
          const SizedBox(width: 10),
          Text(task.name, style: Font.b1),
          const Spacer(),
          ValueDisplay(value: task.score),
        ],
      ),
    );
  }
}
