import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum HabitMode {
  checkbox('CHECKBOX'),
  count('COUNT');

  final String value;
  const HabitMode(this.value);

  static HabitMode fromString(String value) {
    return values.firstWhere((mode) => mode.value == value,
        orElse: () => checkbox);
  }
}

extension HabitModeExtension on HabitMode {
  String get name => <HabitMode, String>{
        HabitMode.checkbox: 'Checkbox',
        HabitMode.count: 'Count',
      }[this]!;

  IconData get icon => <HabitMode, IconData>{
        HabitMode.checkbox: FontAwesomeIcons.circleCheck,
        HabitMode.count: FontAwesomeIcons.arrowUp91,
      }[this]!;
}
