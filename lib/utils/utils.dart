enum Filter { all, positives, negatives }

enum TaskOption { edit, delete }

extension DateExtension on DateTime {
  String toId() => '$year-$month-$day';
  DateTime fromId(String id) => DateTime.parse(id);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  String format() {
    if (isToday) return 'today';
    return '$day/$month/$year';
  }
}
