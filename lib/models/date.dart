import 'dart:convert';

class Date {
  final String id;
  final Set<String> completedTaskIds;
  final int score;

  Date({required this.id, required this.completedTaskIds, this.score = 0});

  // Identifier for database
  static const String tableName = 'dates';
  // column names in database
  static const String id_ = '_id';
  static const String completedTaskIds_ = 'completedTaskIds';
  static const String score_ = 'score';

  Map<String, dynamic> toJson() => {
        id_: id,
        completedTaskIds_: jsonEncode(completedTaskIds.toList()),
        score_: score,
      };

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        id: json[id_],
        completedTaskIds: Set<String>.from(jsonDecode(json[completedTaskIds_])),
        score: json[score_] as int? ?? 0,
      );
}
