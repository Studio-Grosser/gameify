import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String name;
  final int score;

  Task({String? id, required this.name, required this.score})
      : id = id ?? const Uuid().v4();

  // Identifier for database
  static const String tableName = 'tasks';
  // column names in database
  static const String id_ = '_id';
  static const String name_ = 'name';
  static const String score_ = 'score';

  Map<String, dynamic> toJson() => {
        id_: id,
        name_: name,
        score_: score,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json[id_],
        name: json[name_],
        score: json[score_],
      );
}