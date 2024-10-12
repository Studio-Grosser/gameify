import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class NoHabitInfo extends StatelessWidget {
  const NoHabitInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FaIcon(FontAwesomeIcons.folderOpen,
            size: 20, color: theme.colorScheme.secondary),
        const Gap(10),
        Text('no habits yet',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.secondary)),
      ]),
    );
  }
}
