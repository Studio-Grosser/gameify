import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/utils/utils.dart';

class HabitOptionMenu extends StatelessWidget {
  const HabitOptionMenu(
      {super.key,
      required this.isEnabled,
      required this.onDelete,
      required this.onEdit,
      required this.onReset});
  final bool isEnabled;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Opacity(
      opacity: isEnabled ? 1 : 0,
      child: PopupMenuButton<HabitOption>(
          enabled: isEnabled,
          menuPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          icon: FaIcon(FontAwesomeIcons.ellipsisVertical,
              size: 18, color: theme.colorScheme.secondary),
          onSelected: (value) {
            if (value == HabitOption.delete) {
              onDelete();
            } else if (value == HabitOption.edit) {
              onEdit();
            } else if (value == HabitOption.reset) {
              onReset();
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                padding: const EdgeInsets.all(20),
                value: HabitOption.reset,
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.rotateLeft, size: 18),
                    const SizedBox(width: 20),
                    Text('Reset', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.all(20),
                value: HabitOption.edit,
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.pencil, size: 18),
                    const SizedBox(width: 20),
                    Text('Edit', style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.all(20),
                value: HabitOption.delete,
                child: Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.trashCan,
                        size: 18, color: Themes.danger),
                    const SizedBox(width: 20),
                    Text('Delete',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Themes.danger)),
                  ],
                ),
              ),
            ];
          }),
    );
  }
}
