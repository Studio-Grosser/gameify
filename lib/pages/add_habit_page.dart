import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/models/habit_mode.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key, required this.onSubmit, this.initialHabit});
  final Function(Habit) onSubmit;
  final Habit? initialHabit;

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController habitTextController = TextEditingController();
  final TextEditingController habitValueController = TextEditingController();
  final FocusNode habitTextFocusNode = FocusNode();
  final FocusNode habitValueFocusNode = FocusNode();

  AnimationController? _controller;
  Animation<double>? _animation;

  bool isScorePositive = true;
  HabitMode currentHabitMode = HabitMode.checkbox;

  void toggleHabitMode() {
    setState(() {
      currentHabitMode = HabitMode
          .values[(currentHabitMode.index + 1) % HabitMode.values.length];
    });
    jump();
  }

  String get scorePrefix => isScorePositive ? '+' : '-';
  Color get scoreColor => isScorePositive ? Themes.success : Themes.danger;
  String get submitText =>
      widget.initialHabit == null ? 'add habit' : 'edit habit';

  void changeScorePrefix() {
    setState(() {
      isScorePositive = !isScorePositive;
    });
    jump();
  }

  void submitHabit() {
    if (habitTextController.text.trim().isEmpty) {
      habitTextController.text = '';
      _shake();
      habitTextFocusNode.requestFocus();
      return;
    }
    if (habitValueController.text.isEmpty) {
      habitValueFocusNode.requestFocus();
      return;
    }
    Habit newHabit = Habit(
      name: habitTextController.text,
      score: int.parse(habitValueController.text) * (isScorePositive ? 1 : -1),
      createdAt: widget.initialHabit?.createdAt,
    );
    if (!newHabit.hasSameValues(widget.initialHabit)) {
      widget.onSubmit(newHabit);
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialHabit != null) {
      habitTextController.text = widget.initialHabit!.name;
      isScorePositive = widget.initialHabit!.score >= 0;
      habitValueController.text = widget.initialHabit!.score.abs().toString();
    } else {
      habitValueController.text = '10';
    }

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 0, end: 15)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _shake() {
    HapticFeedback.lightImpact();
    _controller?.forward().then((_) {
      HapticFeedback.lightImpact();
      _controller?.reverse();
    });
  }

  double _jumpScale = 1;
  final Duration _animationDuration = const Duration(milliseconds: 50);

  Future<void> jump() async {
    setState(() {
      _jumpScale = 1.1;
    });
    Timer(_animationDuration, () {
      setState(() {
        _jumpScale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: StyledFab(
        text: submitText,
        icon: FontAwesomeIcons.chevronUp,
        onTap: submitHabit,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: StyledIcon(
                    icon: FontAwesomeIcons.xmark,
                    onTap: () => Navigator.pop(context)),
              ),
              const Spacer(flex: 1),
              AnimatedBuilder(
                animation: _animation!,
                builder: (context, child) {
                  return Transform.translate(
                      offset: Offset(_animation!.value, 0), child: child);
                },
                child: TextField(
                    onTapOutside: (_) => FocusScope.of(context).unfocus(),
                    controller: habitTextController,
                    focusNode: habitTextFocusNode,
                    style: theme.textTheme.titleLarge,
                    maxLength: 30,
                    autofocus: true,
                    cursorWidth: 3,
                    cursorColor: Themes.accent,
                    decoration: InputDecoration(
                        counter: const SizedBox(),
                        border: InputBorder.none,
                        hintText: 'add habit description',
                        hintStyle: theme.textTheme.titleLarge
                            ?.copyWith(color: theme.colorScheme.secondary))),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => habitValueFocusNode.requestFocus(),
                    child: StyledContainer(
                        height: 70,
                        borderRadius: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 25),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 25,
                              child: AnimatedScale(
                                scale: _jumpScale,
                                duration: _animationDuration,
                                child: Text(
                                  scorePrefix,
                                  style: theme.textTheme.titleLarge,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                focusNode: habitValueFocusNode,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                cursorColor: Themes.accent,
                                cursorWidth: 3,
                                controller: habitValueController,
                                style: theme.textTheme.titleLarge,
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    isCollapsed: true,
                                    hintText: '10',
                                    hintStyle: theme.textTheme.titleLarge
                                        ?.copyWith(
                                            color: theme.colorScheme.secondary,
                                            fontWeight: FontWeight.w900),
                                    border: InputBorder.none,
                                    counter: const SizedBox()),
                              ),
                            )
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () => changeScorePrefix(),
                    child: StyledContainer(
                        height: 70,
                        width: 70,
                        borderRadius: 50,
                        padding: const EdgeInsets.all(16),
                        child: AnimatedScale(
                          scale: _jumpScale,
                          duration: _animationDuration,
                          curve: Curves.linear,
                          child: Container(
                              decoration: BoxDecoration(
                            color: scoreColor,
                            shape: BoxShape.circle,
                          )),
                        )),
                  ),
                  GestureDetector(
                    onTap: () => toggleHabitMode(),
                    child: StyledContainer(
                        height: 70,
                        width: 70,
                        borderRadius: 50,
                        child: AnimatedScale(
                            scale: _jumpScale,
                            duration: _animationDuration,
                            curve: Curves.linear,
                            child: Center(
                                child:
                                    FaIcon(currentHabitMode.icon, size: 30)))),
                  ),
                ],
              ),
              const Spacer(flex: 3)
            ],
          ),
        ),
      ),
    );
  }
}
