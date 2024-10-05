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
    return Opacity(
      opacity: isEnabled ? 1 : 0,
      child: PopupMenuButton<TaskOption>(
          enabled: isEnabled,
          menuPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                padding: EdgeInsets.all(20),
                value: TaskOption.edit,
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.pencil, size: 18),
                    SizedBox(width: 20),
                    Text('Edit', style: Font.b1),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.all(20),
                value: TaskOption.delete,
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.trashCan,
                        size: 18, color: Themes.warning),
                    const SizedBox(width: 20),
                    Text('Delete',
                        style: Font.b1.copyWith(color: Themes.warning)),
                  ],
                ),
              ),
            ];
          }),
    );
  }
}
