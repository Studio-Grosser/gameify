import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      required this.onChanged,
      required this.onDelete,
      required this.onEdit});
  final Task task;
  final bool isCompleted;
  final Function(bool value) onChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

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
              Text(task.name, style: Font.b1),
              const SizedBox(width: 10),
              Text(task.isActive.toString(), style: Font.b1),
              const Spacer(),
              ValueDisplay(value: task.score),
              PopupMenuButton(
                  enabled: task.isActive,
                  onSelected: (value) {
                    if (value == 2) {
                      onDelete();
                    } else if (value == 1) {
                      onEdit();
                    }
                  },
                  menuPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                      size: 18, color: Themes.primary),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Edit', style: Font.b1),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Delete', style: Font.b1),
                      ),
                    ];
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
