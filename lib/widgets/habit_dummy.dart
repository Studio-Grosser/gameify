import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/theme_provider.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/value_display.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class HabitDummy extends StatelessWidget {
  const HabitDummy({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    ThemeData theme = Theme.of(context);
    return StyledContainer(
      color: themeProvider.isLightTheme ? Themes.shade2 : Themes.shade6,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          const Gap(10),
          Expanded(
              child: Text(habit.name,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)),
          ValueDisplay(value: habit.score),
        ],
      ),
    );
  }
}
