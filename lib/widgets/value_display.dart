import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';

class ValueDisplay extends StatelessWidget {
  const ValueDisplay(
      {super.key, required this.value, this.isDefaultNegative = false});
  final int value;
  final bool isDefaultNegative;

  Color get color {
    if (value == 0) return isDefaultNegative ? Themes.warning : Themes.success;
    return value > 0 ? Themes.success : Themes.warning;
  }

  String get text {
    if (value == 0) return isDefaultNegative ? '-0' : '+0';
    return value > 0 ? '+$value' : '$value';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Center(
            child: Text(text, style: Font.b1.copyWith(color: Themes.surface))));
  }
}
