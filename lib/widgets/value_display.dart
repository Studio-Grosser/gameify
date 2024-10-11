import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Center(
            child: Text(value.abs().toString(),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Themes.surface))));
  }
}
