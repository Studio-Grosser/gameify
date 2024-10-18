import 'package:flutter/material.dart';
import 'package:gameify/database/habit_service.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/habit_manager.dart';
import 'package:gameify/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:gameify/widgets/filter_slider.dart';
import 'package:gameify/widgets/heat_map/heat_map.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/no_habit_info.dart';
import 'package:gameify/widgets/score_display.dart';
import 'package:gameify/widgets/settings_drawer.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';
import 'package:gameify/widgets/habit_display.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  void openAddHabitPage({Habit? initialHabit}) {
    void onSubmit(Habit habit) async {
      if (initialHabit != null) {
        await context
            .read<HabitManager>()
            .onHabitDelete(context, initialHabit, confirm: false);
      }
      await Habitservice().writeHabit(habit);
    }

    context.go('/main/addHabit', extra: [onSubmit, initialHabit]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: StyledFab(
        padding: EdgeInsets.zero,
        height: 70,
        width: 70,
        icon: CupertinoIcons.plus,
        onTap: () => openAddHabitPage(),
      ),
      endDrawer: const SettingsDrawer(),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
          child: Consumer<HabitManager>(
            builder: (context, habitManager, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(habitManager.currentDate.format(),
                          style: theme.textTheme.titleMedium),
                      const Spacer(),
                      StyledIcon(
                        icon: CupertinoIcons.calendar,
                        onTap: () => showCalendar(
                          context: context,
                          currentDate: habitManager.currentDate,
                          changeDate: habitManager.changeDate,
                        ),
                      ),
                      StyledIcon(
                        icon: CupertinoIcons.settings,
                        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
                      )
                    ],
                  ),
                  const Gap(20),
                  ScoreDisplay(
                    score: habitManager.score,
                    negativeScore: habitManager.negativeScore,
                    positiveScore: habitManager.positiveScore,
                  ),
                  Expanded(
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        Row(
                          children: [
                            MetricDisplay(
                                metric: habitManager.average, unit: 'average'),
                            MetricDisplay(
                                metric: habitManager.highscore,
                                unit: 'highscore'),
                          ],
                        ),
                        HeatMap(
                          dates: habitManager.allDates ?? [],
                          currentDate: habitManager.currentDate,
                        ),
                        const Gap(100),
                        FilterSlider(
                          currentFilter: habitManager.currentFilter,
                          onChanged: (newFilter) {
                            habitManager.changeFilter(newFilter ?? Filter.all);
                          },
                        ),
                        const Gap(10),
                        habitManager.filteredHabits.isEmpty
                            ? const NoHabitInfo()
                            : ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(bottom: 100),
                                shrinkWrap: true,
                                itemCount: habitManager.filteredHabits.length,
                                itemBuilder: (context, index) {
                                  Habit habit =
                                      habitManager.filteredHabits[index];
                                  int? value =
                                      habitManager.getHabitValue(habit.id);
                                  return HabitDisplay(
                                    habit: habit,
                                    value: value,
                                    onTap: () => habitManager.onHabitTap(habit),
                                    onDelete: () => habitManager.onHabitDelete(
                                        context, habit),
                                    onEdit: () =>
                                        openAddHabitPage(initialHabit: habit),
                                    onReset: () =>
                                        habitManager.resetHabit(habit.id),
                                  );
                                }),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
