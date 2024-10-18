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

  bool get isToday => isSameDay(DateTime.now());
  bool isSameDay(DateTime b) =>
      year == b.year && month == b.month && day == b.day;

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  DateTime get startOfDay => DateTime(year, month, day);

  String format() {
    if (isToday) return 'time.today'.tr();
    if (isYesterday) return 'time.yesterday'.tr();
    if (isTomorrow) return 'time.tomorrow'.tr();
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
