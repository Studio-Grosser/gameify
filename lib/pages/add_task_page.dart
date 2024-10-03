import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_fab.dart';
import 'package:gameify/widgets/styled_icon.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.onTaskAdded});
  final Function(Task) onTaskAdded;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController taskTextController = TextEditingController();
  final TextEditingController taskValueController =
      TextEditingController(text: '10');
  final FocusNode taskValueFocusNode = FocusNode();

  bool isScorePositive = true;

  String get scorePrefix => isScorePositive ? '+' : '-';
  Color get scoreColor => isScorePositive ? Themes.success : Themes.warning;

  void changeScorePrefix() {
    setState(() {
      isScorePositive = !isScorePositive;
    });
  }

  void submitTask() {
    if (taskTextController.text.isEmpty || taskValueController.text.isEmpty) {
      return;
    }
    widget.onTaskAdded(Task(
      name: taskTextController.text,
      score: int.parse(taskValueController.text) * (isScorePositive ? 1 : -1),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StyledFab(
        text: 'add task',
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
              TextField(
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  controller: taskTextController,
                  style: Font.h2,
                  maxLength: 30,
                  autofocus: true,
                  cursorWidth: 3,
                  cursorColor: Themes.accent,
                  decoration: InputDecoration(
                      counter: const SizedBox(),
                      border: InputBorder.none,
                      hintText: 'add task description',
                      hintStyle: Font.h2.copyWith(color: Themes.secondary))),
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
                              child: Text(
                                scorePrefix,
                                style: Font.h1,
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
                                style: Font.h1,
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: '10',
                                    hintStyle: Font.h1
                                        .copyWith(color: Themes.secondary),
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
                        child: Container(
                            decoration: BoxDecoration(
                          color: scoreColor,
                          shape: BoxShape.circle,
                        ))),
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
