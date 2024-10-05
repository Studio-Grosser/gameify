enum Filter { all, positives, negatives }

enum TaskOption { edit, delete }

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

  String format() {
    if (isToday) return 'today';
    return '$day/$month/$year';
  }
}
