import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/utils/utils.dart';

class TaskOptionMenu extends StatelessWidget {
  const TaskOptionMenu(
      {super.key,
      required this.isEnabled,
      required this.onDelete,
      required this.onEdit});
  final bool isEnabled;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskOption>(
        enabled: isEnabled,
        menuPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
            size: 18, color: Themes.primary),
        onSelected: (value) {
          if (value == TaskOption.delete) {
            onDelete();
          } else if (value == TaskOption.edit) {
            onEdit();
          }
        },
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: TaskOption.edit,
              child: Text('Edit', style: Font.b1),
            ),
            const PopupMenuItem(
              value: TaskOption.delete,
              child: Text('Delete', style: Font.b1),
            ),
          ];
        });
  }
}
