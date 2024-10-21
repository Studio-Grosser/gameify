import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';

class ScoreDisplay extends StatelessWidget {
  const ScoreDisplay(
      {super.key, required this.value, this.isDefaultNegative = false});
  final int value;
  final bool isDefaultNegative;

  Color get color {
    if (value == 0) return isDefaultNegative ? Themes.danger : Themes.success;
    return value > 0 ? Themes.success : Themes.danger;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        width: 40,
        height: 25,
        padding: const EdgeInsets.symmetric(vertical: 3),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Center(
            child: Text(value.abs().toString(),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Themes.shade1))));
  }
}
