import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/date_day_display.dart';
import 'package:collection/collection.dart';
import 'package:gameify/widgets/styled_icon.dart';

enum Direction { forward, backward }

class HeatMap extends StatefulWidget {
  const HeatMap({
    super.key,
    required this.onSelection,
    this.selectedDate,
    required this.data,
  });
  final Function(DateTime?) onSelection;
  final DateTime? selectedDate;
  final Map<DateTime, double> data;

  @override
  State<HeatMap> createState() => _HeatMapState();
}

class _HeatMapState extends State<HeatMap> {
  static const totalMonths = 12;
  static const totalWeekdays = 7;
  static const weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late DateTime selectedMonthAndYear;
  late DateTime minimumDate;
  late DateTime maximumDate;

  bool get goBackMonthLimit => minimumDate.isBefore(selectedMonthAndYear);

  bool get goNextMonthLimit => maximumDate.isAfter(selectedMonthAndYear);

  /// Returns the amount of days in the given month
  int calcDaysInMonth(int year, int month) {
    final DateTime currentMonth = DateTime(year, month);
    final DateTime nextMonth = DateTime(year, month + 1);
    return nextMonth.difference(currentMonth).inDays;
  }

  String get calendarTitle {
    int monthIndex = (selectedMonthAndYear.month - 1) % totalMonths;
    return '${months[monthIndex]} ${selectedMonthAndYear.year}';
  }

  void changeMonth(Direction direction) {
    DateTime newDate = DateTime.now();
    //we use 50 and 10 as MagicNumbers here, since Duration has no "month" attribute.
    //therefore we need to add/subtract an specific amount of days to "land" in the next/last
    //month. This is possible, because the variable "selectedMonthAndYear" has ALWAYS the
    //first day of the month.
    if (direction == Direction.forward) {
      if (!goNextMonthLimit) return;
      newDate = selectedMonthAndYear.add(const Duration(days: 50));
    } else if (direction == Direction.backward) {
      if (!goBackMonthLimit) return;
      newDate = selectedMonthAndYear.subtract(const Duration(days: 10));
    }
    setState(() {
      selectedMonthAndYear = DateTime(newDate.year, newDate.month);
    });
  }

  TableRow get weekDayTableRow {
    return TableRow(children: [
      for (int i = 0; i < totalWeekdays; i++) ...[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            weekdays[i],
            style: Font.b1,
            textAlign: TextAlign.center,
          ),
        )
      ]
    ]);
  }

  List<TableRow> get daysTableRows {
    List<DateDayDisplay> dateDayDisplays = [];

    int startingDay = selectedMonthAndYear.weekday;
    int daysInMonth =
        calcDaysInMonth(selectedMonthAndYear.year, selectedMonthAndYear.month);
    for (int i = 0; i < startingDay - 1; i++) {
      dateDayDisplays.add(const DateDayDisplay(isSelectable: false));
    }

    for (int i = 0; i < daysInMonth; i++) {
      final DateTime date = DateTime(
          selectedMonthAndYear.year, selectedMonthAndYear.month, i + 1);
      dateDayDisplays.add(DateDayDisplay(
        day: date.day,
        date: date,
        heatFactor: widget.data[date] ?? 0.0,
        isSelected: date == widget.selectedDate,
        isSelectable: true,
        onSelected: (newDate) => widget.onSelection(newDate),
      ));
    }

    //If no date is selected (when opening the date picker the first time)
    //then the first available date will be selected
    if (widget.selectedDate == null) {
      DateTime? firstAvailableDate =
          dateDayDisplays.firstWhereOrNull((date) => date.isSelectable)?.date;
      if (firstAvailableDate != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onSelection(
              dateDayDisplays.firstWhere((date) => date.isSelectable).date);
        });
      }
    }

    int remaining = totalWeekdays - (dateDayDisplays.length % totalWeekdays);
    if (remaining != totalWeekdays) {
      for (int i = 0; i < remaining; i++) {
        dateDayDisplays.add(const DateDayDisplay(isSelectable: false));
      }
    }

    List<TableRow> tableRows = [];
    for (int i = 0; i < dateDayDisplays.length / totalWeekdays; i++) {
      List<DateDayDisplay> displays = [];
      for (int j = 0; j < totalWeekdays; j++) {
        displays.add(dateDayDisplays[i * 7 + j]);
      }
      tableRows.add(TableRow(children: displays));
    }

    return tableRows;
  }

  void horizontalDrag(DragEndDetails dragDetails) {
    if (dragDetails.primaryVelocity! < 0) {
      changeMonth(Direction.forward);
    } else if (dragDetails.primaryVelocity! > 0) {
      changeMonth(Direction.backward);
    }
  }

  @override
  void initState() {
    selectedMonthAndYear = DateTime(DateTime.now().year, DateTime.now().month);
    minimumDate =
        DateTime(selectedMonthAndYear.year - 3, selectedMonthAndYear.month);
    maximumDate = selectedMonthAndYear;
    if (widget.selectedDate != null) {
      selectedMonthAndYear =
          DateTime(widget.selectedDate!.year, widget.selectedDate!.month);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            StyledIcon(
                icon: FontAwesomeIcons.chevronLeft,
                onTap: () => changeMonth(Direction.backward)),
            Text(calendarTitle, style: Font.b1.copyWith(color: Themes.accent)),
            StyledIcon(
                icon: FontAwesomeIcons.chevronRight,
                onTap: () => changeMonth(Direction.forward)),
          ]),
          const SizedBox(height: 30),
          GestureDetector(
            onHorizontalDragEnd: (details) => horizontalDrag(details),
            child: Center(
              child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  defaultColumnWidth: const FlexColumnWidth(),
                  children: [weekDayTableRow, ...daysTableRows]),
            ),
          ),
        ]);
  }
}
