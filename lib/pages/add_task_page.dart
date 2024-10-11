import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.onSubmit, this.initialTask});
  final Function(Task) onSubmit;
  final Task? initialTask;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController taskTextController = TextEditingController();
  final TextEditingController taskValueController = TextEditingController();
  final FocusNode taskTextFocusNode = FocusNode();
  final FocusNode taskValueFocusNode = FocusNode();

  AnimationController? _controller;
  Animation<double>? _animation;

  bool isScorePositive = true;

  String get scorePrefix => isScorePositive ? '+' : '-';
  Color get scoreColor => isScorePositive ? Themes.success : Themes.warning;
  String get submitText =>
      widget.initialTask == null ? 'add task' : 'edit task';

  void changeScorePrefix() {
    setState(() {
      isScorePositive = !isScorePositive;
    });
    jump();
  }

  void submitTask() {
    if (taskTextController.text.trim().isEmpty) {
      taskTextController.text = '';
      _shake();
      taskTextFocusNode.requestFocus();
      return;
    }
    if (taskValueController.text.isEmpty) {
      taskValueFocusNode.requestFocus();
      return;
    }
    Task newTask = Task(
      name: taskTextController.text,
      score: int.parse(taskValueController.text) * (isScorePositive ? 1 : -1),
    );
    if (!newTask.hasSameValues(widget.initialTask)) {
      widget.onSubmit(newTask);
    }
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialTask != null) {
      taskTextController.text = widget.initialTask!.name;
      isScorePositive = widget.initialTask!.score >= 0;
      taskValueController.text = widget.initialTask!.score.abs().toString();
    } else {
      taskValueController.text = '10';
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
        onTap: submitTask,
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
                    controller: taskTextController,
                    focusNode: taskTextFocusNode,
                    style: theme.textTheme.titleLarge,
                    maxLength: 30,
                    autofocus: true,
                    cursorWidth: 3,
                    cursorColor: Themes.accent,
                    decoration: InputDecoration(
                        counter: const SizedBox(),
                        border: InputBorder.none,
                        hintText: 'add task description',
                        hintStyle: theme.textTheme.titleLarge
                            ?.copyWith(color: theme.colorScheme.secondary))),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => taskValueFocusNode.requestFocus(),
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
                                focusNode: taskValueFocusNode,
                                onTapOutside: (_) =>
                                    FocusScope.of(context).unfocus(),
                                cursorColor: Themes.accent,
                                cursorWidth: 3,
                                controller: taskValueController,
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
                  const SizedBox(width: 5),
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
