import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/models/habit_mode.dart';
import 'package:gameify/widgets/styled/styled_fab.dart';
import 'package:gameify/widgets/habit/habit_display.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static final List<Habit> habits = [
    Habit(name: 'Go to the gym', score: 20, mode: HabitMode.checkbox),
    Habit(name: 'Read 10 pages', score: 5, mode: HabitMode.checkbox),
    Habit(name: 'Take a 30 minute walk', score: 10, mode: HabitMode.checkbox),
    Habit(name: 'Watch Netflix', score: -5, mode: HabitMode.checkbox),
    Habit(name: 'Eat fast food', score: -10, mode: HabitMode.checkbox),
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('choose your first habits', style: theme.textTheme.bodyLarge),
            const Gap(60),
            ...habits.map((habit) => HabitDisplay(
                  habit: habit,
                  value: habitIds.contains(habit.id) ? 1 : 0,
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
