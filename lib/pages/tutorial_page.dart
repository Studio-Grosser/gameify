// ignore_for_file: prefer_const_constructors

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/models/habit_mode.dart';
import 'package:gameify/widgets/habit/habit_display.dart';
import 'package:gameify/widgets/styled/styled_fab.dart';
import 'package:gap/gap.dart';

import 'package:go_router/go_router.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final Habit habitOne =
      Habit(name: 'Go to the Gym', score: 20, mode: HabitMode.checkbox);
  final Habit habitTwo =
      Habit(name: 'Eat Fast Food', score: -10, mode: HabitMode.checkbox);
  final Habit habitThree =
      Habit(name: 'Read 10 pages', score: 5, mode: HabitMode.count);
  void onSubmit() async {
    if (!mounted) return;
    context.go('/tutorial/suggestions');
  }

  String text = 'Complete habits to increase your score';

  double textOpacity = 0;
  double scoreOpacity = 0;
  double habitOneOpacity = 0;
  double habitTwoOpacity = 0;
  double habitThreeOpacity = 0;
  bool isHabitOneDone = false;
  bool isHabitTwoDone = false;
  int habitThreeValue = 0;

  int scoreValue = 0;
  bool tutorialDone = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      one();
    });
    super.initState();
  }

  void one() async {
    setState(() {
      textOpacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      habitOneOpacity = 1;
    });
  }

  void onHabitOneTap() async {
    if (isHabitOneDone) return;
    setState(() {
      isHabitOneDone = true;
      scoreOpacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      scoreValue += habitOne.score;
    });
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      textOpacity = 0;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      text = 'Bad habits will decrease your score';
      textOpacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      habitOneOpacity = 0.25;
      habitTwoOpacity = 1;
    });
  }

  void onHabitTwoTap() async {
    if (isHabitTwoDone) return;
    setState(() {
      isHabitTwoDone = true;
    });
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      scoreValue += habitTwo.score;
    });
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      textOpacity = 0;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      text =
          'Create counter habits to complete habits several times in one day';
      textOpacity = 1;
    });
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      habitTwoOpacity = 0.25;

      habitThreeOpacity = 1;
    });
  }

  void onHabitThreeTap() async {
    if (habitThreeValue != 3) {
      setState(() {
        habitThreeValue++;
        scoreValue += habitThree.score;
      });
    } else {
      setState(() {
        textOpacity = 0;
      });
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        text = 'Tap and hold a counter habit to reset its value';
        textOpacity = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        floatingActionButton: tutorialDone
            ? StyledFab(
                padding: EdgeInsets.zero,
                icon: CupertinoIcons.chevron_right,
                onTap: onSubmit,
                height: 70,
                width: 70,
              )
            : null,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Gap(50),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1500),
                  opacity: scoreOpacity,
                  child: AnimatedFlipCounter(
                    value: scoreValue,
                    textStyle: theme.textTheme.titleLarge,
                    duration: Duration(milliseconds: 500),
                  ),
                ),
                Gap(75),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: textOpacity,
                  child: SizedBox(
                    height: 150,
                    child: Text(
                      text,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: habitOneOpacity,
                  child: HabitDisplay(
                    habit: habitOne,
                    onTap: onHabitOneTap,
                    value: isHabitOneDone ? 1 : 0,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: habitTwoOpacity,
                  child: HabitDisplay(
                    habit: habitTwo,
                    onTap: onHabitTwoTap,
                    value: isHabitTwoDone ? 1 : 0,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: habitThreeOpacity,
                  child: HabitDisplay(
                    onReset: habitThreeValue == 3
                        ? () {
                            setState(() {
                              habitThreeValue = 0;
                              scoreValue -= habitThree.score * 3;
                              tutorialDone = true;
                            });
                          }
                        : null,
                    habit: habitThree,
                    onTap: onHabitThreeTap,
                    value: habitThreeValue,
                  ),
                ),
              ]),
            ),
          ),
        ));
  }
}