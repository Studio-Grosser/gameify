import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/widgets/styled/styled_container.dart';
import 'package:gameify/widgets/score_display.dart';
import 'package:gap/gap.dart';

class HabitDummy extends StatelessWidget {
  const HabitDummy({super.key, required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return StyledContainer(
      color: theme.colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        children: [
          const Gap(10),
          Expanded(
              child: Text(habit.name,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)),
          ScoreDisplay(value: habit.score),
        ],
      ),
    );
  }
}
