import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gameify/widgets/date_picker/custom_date_picker.dart';

class DateCollection {
  static List<String> months = [
    'time.months.0'.tr(),
    'time.months.1'.tr(),
    'time.months.2'.tr(),
    'time.months.3'.tr(),
    'time.months.4'.tr(),
    'time.months.5'.tr(),
    'time.months.6'.tr(),
    'time.months.7'.tr(),
    'time.months.8'.tr(),
    'time.months.9'.tr(),
    'time.months.10'.tr(),
    'time.months.11'.tr()
  ];

  static List<String> weekdays = [
    'time.weekdays.0'.tr(),
    'time.weekdays.1'.tr(),
    'time.weekdays.2'.tr(),
    'time.weekdays.3'.tr(),
    'time.weekdays.4'.tr(),
    'time.weekdays.5'.tr(),
    'time.weekdays.6'.tr()
  ];
}

DateTime fromId(String id) {
  final parts = id.split('-');
  return DateTime(
      int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

extension DateExtension on DateTime {
  String toId() => '$year-$month-$day';

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);

  String format() {
    if (isToday) return 'today';
    return '$day/$month/$year';
  }
}

void showCalendar(
    {required BuildContext context,
    required DateTime currentDate,
    required Function(DateTime) changeDate}) async {
  if (!context.mounted) return;
  showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CustomDatePicker(
            onChanged: changeDate, selectedDate: currentDate.startOfDay);
      });
}
