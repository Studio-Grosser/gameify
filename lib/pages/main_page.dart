import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/date_utils.dart';
import 'package:gameify/utils/habit_manager.dart';
import 'package:gameify/utils/logger.dart';
import 'package:gameify/utils/session_utils.dart';
import 'package:gameify/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:gameify/widgets/filter_slider.dart';
import 'package:gameify/widgets/heat_map/heat_map.dart';
import 'package:gameify/widgets/metric_display.dart';
import 'package:gameify/widgets/habit/no_habit_info.dart';
import 'package:gameify/widgets/score_overview.dart';
import 'package:gameify/widgets/settings_drawer.dart';
import 'package:gameify/widgets/styled/styled_fab.dart';
import 'package:gameify/widgets/styled/styled_icon.dart';
import 'package:gameify/widgets/habit/habit_display.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  late ConfettiController _confettiController;

  void openAddHabitPage({Habit? initialHabit}) {
    void onSubmit(Habit habit) async {
      HabitManager habitManager = context.read<HabitManager>();
      if (initialHabit != null) {
        await habitManager.onHabitDelete(context, initialHabit, confirm: false);
      }
      await habitManager.addHabit(habit);
    }

    context.go('/main/addHabit', extra: [onSubmit, initialHabit]);
  }

  @override
  void initState() {
    HabitManager habitManager = context.read<HabitManager>();
    WidgetsBinding.instance.addObserver(this);
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    habitManager.setNewHighscoreCallback(() => _confettiController.play());
    SessionUtils.registerSession();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Logger.i('App resumed');
      bool isSessionExpired = await SessionUtils.isSessionExpired();
      if (isSessionExpired) {
        if (mounted) context.read<HabitManager>().resetDate();
        SessionUtils.registerSession();
      }
    }
    super.didChangeAppLifecycleState(state);
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
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: pi / 4,
                  shouldLoop: false,
                  numberOfParticles: 10,
                  blastDirectionality: BlastDirectionality.explosive,
                )),
            Padding(
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
                            onTap: () =>
                                _scaffoldKey.currentState?.openEndDrawer(),
                          )
                        ],
                      ),
                      const Gap(20),
                      ScoreOverview(
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
                                    metric: habitManager.average,
                                    unit: 'score.average'.tr()),
                                MetricDisplay(
                                    metric: habitManager.highscore,
                                    unit: 'score.highscore'.tr()),
                              ],
                            ),
                            HeatMap(
                              dates: habitManager.allDates ?? [],
                              currentDate: habitManager.currentDate,
                            ),
                            const Gap(80),
                            FilterSlider(
                              currentFilter: habitManager.currentFilter,
                              onChanged: (newFilter) {
                                habitManager
                                    .changeFilter(newFilter ?? Filter.all);
                              },
                            ),
                            const Gap(10),
                            habitManager.filteredHabits.isEmpty
                                ? const NoHabitInfo()
                                : ListView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.only(bottom: 100),
                                    shrinkWrap: true,
                                    itemCount:
                                        habitManager.filteredHabits.length,
                                    itemBuilder: (context, index) {
                                      Habit habit =
                                          habitManager.filteredHabits[index];
                                      int? value =
                                          habitManager.getHabitValue(habit.id);
                                      return HabitDisplay(
                                        habit: habit,
                                        value: value,
                                        onTap: () =>
                                            habitManager.onHabitTap(habit),
                                        onDelete: () => habitManager
                                            .onHabitDelete(context, habit),
                                        onEdit: () => openAddHabitPage(
                                            initialHabit: habit),
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
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _confettiController.dispose();
    super.dispose();
  }
}
