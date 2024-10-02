extension DateId on DateTime {
  String toId() => '$year-$month-$day';
  DateTime fromId(String id) => DateTime.parse(id);
}
