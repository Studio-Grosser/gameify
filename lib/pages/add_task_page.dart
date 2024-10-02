import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/task.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/styled_icon.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key, required this.onTaskAdded});
  final Function(Task) onTaskAdded;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController taskTextController = TextEditingController();
  final TextEditingController taskValueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StyledIcon(
                icon: FontAwesomeIcons.xmark,
                onTap: () => Navigator.pop(context)),
            TextField(controller: taskTextController),
            TextField(
                controller: taskValueController,
                keyboardType: TextInputType.number),
            IconButton(
                onPressed: () {
                  widget.onTaskAdded(Task(
                    name: taskTextController.text,
                    score: int.parse(taskValueController.text),
                  ));
                  Navigator.pop(context);
                },
                icon: Icon(Icons.check))
          ],
        ),
      ),
    );
  }
}
