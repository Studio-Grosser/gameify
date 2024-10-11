import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/utils/utils.dart';

class DateDayDisplay extends StatefulWidget {
  const DateDayDisplay(
      {super.key,
      this.day,
      required this.isSelectable,
      this.date,
      this.isSelected = false,
      this.onSelected,
      this.heatFactor});
  final int? day;
  final DateTime? date;
  final bool isSelectable;
  final bool isSelected;
  final double? heatFactor;
  final Function(DateTime?)? onSelected;

  @override
  State<DateDayDisplay> createState() => _DateDayDisplayState();
}

class _DateDayDisplayState extends State<DateDayDisplay> {
  Color? get bubbleColor {
    if (widget.isSelected == true) return Themes.accent;
    if (widget.date!.isToday) {
      return Themes.accent.withValues(alpha: widget.heatFactor);
    }
    return Themes.success.withValues(alpha: widget.heatFactor);
  }

  Color get textColor {
    if (widget.isSelected == true) return Themes.surface;
    if ((widget.heatFactor ?? 0) > 0) {
      return Themes.surface;
    }
    return Themes.secondary;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.day == null) return const SizedBox();
    double size = 40;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: widget.isSelectable
              ? () => widget.onSelected!(widget.date!)
              : null,
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
                    widget.day.toString(),
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
