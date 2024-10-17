import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/utils/utils.dart';

class DateDayDisplay extends StatefulWidget {
  const DateDayDisplay({
    super.key,
    this.date,
    this.isSelected = false,
    this.onSelected,
  });
  final DateTime? date;
  final bool isSelected;
  final Function(DateTime?)? onSelected;

  @override
  State<DateDayDisplay> createState() => _DateDayDisplayState();
}

class _DateDayDisplayState extends State<DateDayDisplay> {
  Color? get bubbleColor => widget.isSelected ? Themes.accent : null;

  Color get textColor {
    return widget.isSelected
        ? Themes.shade1
        : Theme.of(context).textTheme.bodyMedium!.color!;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.date == null) return const SizedBox();
    double size = 40;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () => widget.onSelected!(widget.date!),
          child: Ink(
            height: size,
            width: size,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(40),
                        border: widget.date!.isToday
                            ? Border.all(width: 2, color: Themes.accent)
                            : null),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.date!.day.toString(),
                    style:
                        theme.textTheme.bodyMedium?.copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
