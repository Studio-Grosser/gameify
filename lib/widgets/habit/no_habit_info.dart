import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameify/utils/responsive_utils.dart';
import 'package:gap/gap.dart';

class NoHabitInfo extends StatelessWidget {
  const NoHabitInfo({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Gap(responsiveHeight(100, context)),
      Icon(CupertinoIcons.folder_open,
          size: 20, color: theme.colorScheme.secondary),
      const Gap(10),
      Text('habit.empty'.tr(),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.secondary)),
    ]);
  }
}
