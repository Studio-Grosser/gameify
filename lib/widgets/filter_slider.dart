import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameify/models/habit.dart';
import 'package:gameify/utils/utils.dart';

class FilterSlider extends StatelessWidget {
  const FilterSlider(
      {super.key, required this.currentFilter, required this.onChanged});
  final Filter currentFilter;
  final Function(Filter?) onChanged;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
        width: double.infinity,
        child: CupertinoSlidingSegmentedControl<Filter>(
          backgroundColor: theme.colorScheme.primaryContainer,
          thumbColor: theme.colorScheme.secondaryContainer,
          groupValue: currentFilter,
          children: Habit.filters.map((key, value) =>
              MapEntry(key, Text(value, style: theme.textTheme.bodyMedium))),
          onValueChanged: onChanged,
        ));
  }
}
