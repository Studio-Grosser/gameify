import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';

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
  late DateTime currentDate;

  @override
  void initState() {
    final DateTime now = DateTime.now();
    currentDate = DateTime(now.year, now.month, now.day);
    super.initState();
  }

  Color? get bubbleColor {
    if (widget.isSelected == true) return Themes.accent;
    return Themes.success.withValues(alpha: widget.heatFactor);
  }

  Color get textColor {
    if (widget.isSelected == true) return Themes.surface;
    if (widget.date == currentDate) return Themes.accent;
    if (widget.isSelectable) return Themes.secondary;
    return Themes.tertiary;
  }

  @override
  Widget build(BuildContext context) {
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
                        borderRadius: BorderRadius.circular(40)),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    widget.day.toString(),
                    style: Font.b1.copyWith(color: textColor),
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
