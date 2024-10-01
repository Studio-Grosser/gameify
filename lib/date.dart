import 'dart:convert';

class Date {
  final String id;
  final Set<String> completedTaskIds;

  Date({required this.id, required this.completedTaskIds});

  // Identifier for database
  static const String tableName = 'dates';
  // column names in database
  static const String id_ = '_id';
  static const String completedTaskIds_ = 'completedTaskIds';

  Map<String, dynamic> toJson() => {
        id_: id,
        completedTaskIds_: jsonEncode(completedTaskIds.toList()),
      };

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        id: json[id_],
        completedTaskIds: Set<String>.from(jsonDecode(json[completedTaskIds_])),
      );
}
