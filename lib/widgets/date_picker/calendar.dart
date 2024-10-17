import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/date_picker/date_day_display.dart';

enum Direction { forward, backward }

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.onSelection,
    this.selectedDate,
    required this.data,
  });
  final Function(DateTime?) onSelection;
  final DateTime? selectedDate;
  final Map<DateTime, double> data;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static int get totalMonths => months.length;
  static int get totalWeekdays => weekdays.length;
  static const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    'December'
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
            style: Theme.of(context).textTheme.bodyMedium,
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
      dateDayDisplays.add(const DateDayDisplay());
    }

    for (int i = 0; i < daysInMonth; i++) {
      final DateTime date = DateTime(
          selectedMonthAndYear.year, selectedMonthAndYear.month, i + 1);
      dateDayDisplays.add(DateDayDisplay(
        date: date,
        isSelected: date == widget.selectedDate,
        onSelected: (newDate) => widget.onSelection(newDate),
      ));
    }

    int remaining = totalWeekdays - (dateDayDisplays.length % totalWeekdays);
    if (remaining != totalWeekdays) {
      for (int i = 0; i < remaining; i++) {
        dateDayDisplays.add(const DateDayDisplay());
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
    super.initState();
    selectedMonthAndYear = DateTime(DateTime.now().year, DateTime.now().month);
    minimumDate =
        DateTime(selectedMonthAndYear.year - 3, selectedMonthAndYear.month);
    maximumDate = selectedMonthAndYear;
    if (widget.selectedDate != null) {
      selectedMonthAndYear =
          DateTime(widget.selectedDate!.year, widget.selectedDate!.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            IconButton(
                onPressed: !goBackMonthLimit
                    ? null
                    : () => changeMonth(Direction.backward),
                disabledColor: theme.colorScheme.tertiary,
                color: Themes.accent,
                icon: const Icon(CupertinoIcons.chevron_back, size: 24)),
            Text(calendarTitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Themes.accent)),
            IconButton(
                onPressed: !goNextMonthLimit
                    ? null
                    : () => changeMonth(Direction.forward),
                disabledColor: theme.colorScheme.tertiary,
                color: Themes.accent,
                icon: const Icon(CupertinoIcons.chevron_forward, size: 24)),
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
