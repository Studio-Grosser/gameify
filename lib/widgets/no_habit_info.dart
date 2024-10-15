import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        Icon(CupertinoIcons.folder_open,
            size: 20, color: theme.colorScheme.secondary),
        const Gap(10),
        Text('no habits yet',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.secondary)),
      ]),
    );
  }
}
