import 'dart:convert';

class Date {
  final String id;
  final Set<String> completedHabitIds;
  final int score;

  Date({required this.id, required this.completedHabitIds, this.score = 0});

  // Identifier for database
  static const String tableName = 'dates';
  // column names in database
  static const String id_ = '_id';
  static const String completedHabitIds_ = 'completedHabitIds';
  static const String score_ = 'score';

  Map<String, dynamic> toJson() => {
        id_: id,
        completedHabitIds_: jsonEncode(completedHabitIds.toList()),
        score_: score,
      };

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        id: json[id_],
        completedHabitIds:
            Set<String>.from(jsonDecode(json[completedHabitIds_])),
        score: json[score_] as int? ?? 0,
      );
}
