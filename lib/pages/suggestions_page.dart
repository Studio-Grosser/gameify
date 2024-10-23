import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/models/habit_mode.dart';
import 'package:gameify/widgets/page_padding.dart';
import 'package:gameify/widgets/styled/styled_fab.dart';
import 'package:gameify/widgets/habit/habit_display.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({super.key});

  @override
  State<SuggestionsPage> createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  static final List<Habit> habits = [
    Habit(
        name: 'habit.suggestions.0'.tr(), score: 20, mode: HabitMode.checkbox),
    Habit(name: 'habit.suggestions.1'.tr(), score: 5, mode: HabitMode.count),
    Habit(
        name: 'habit.suggestions.2'.tr(), score: 10, mode: HabitMode.checkbox),
    Habit(
        name: 'habit.suggestions.3'.tr(), score: -5, mode: HabitMode.checkbox),
    Habit(
        name: 'habit.suggestions.4'.tr(), score: -10, mode: HabitMode.checkbox),
  ];

  List<String> habitIds = [];

  void onSubmit() async {
    List<Habit> selectedHabits =
        habits.where((habit) => habitIds.contains(habit.id)).toList();

    for (var habit in selectedHabits) {
      await Habitservice().writeHabit(habit);
    }

    if (!mounted) return;
    context.go('/main');
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: StyledFab(
        padding: const EdgeInsets.all(0),
        height: 70,
        width: 70,
        icon: CupertinoIcons.chevron_right,
        onTap: onSubmit,
      ),
      body: PagePadding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('habit.suggestions.title'.tr(),
                style: theme.textTheme.bodyLarge),
            const Gap(60),
            ...habits.map((habit) => HabitDisplay(
                  showCheckbox: false,
                  habit: habit,
                  showSelectionBorder: habitIds.contains(habit.id),
                  onTap: () {
                    setState(() {
                      !habitIds.contains(habit.id)
                          ? habitIds.add(habit.id)
                          : habitIds.remove(habit.id);
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
