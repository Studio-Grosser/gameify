import 'package:gameify/utils/utils.dart';
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String name;
  final int score;
  final DateTime createdAt;
  bool isActive;

  Task(
      {String? id,
      DateTime? createdAt,
      required this.name,
      required this.score,
      this.isActive = true})
      : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  static const Map<Filter, String> filters = {
    Filter.all: 'all',
    Filter.positives: 'positives',
    Filter.negatives: 'negatives',
  };

  // Identifier for database
  static const String tableName = 'tasks';
  // column names in database
  static const String id_ = '_id';
  static const String name_ = 'name';
  static const String score_ = 'score';
  static const String isActive_ = 'active';
  static const String createdAt_ = 'created_at';

  void toggleActive() => isActive = !isActive;

  bool hasSameValues(Task? b) => name == b?.name && score == b?.score;

  Map<String, dynamic> toJson() => {
        id_: id,
        name_: name,
        score_: score,
        createdAt_: createdAt.toIso8601String(),
        isActive_: isActive ? 1 : 0
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json[id_],
        name: json[name_],
        score: json[score_],
        createdAt: DateTime.parse(json[createdAt_]),
        isActive: json[isActive_] == 1,
      );
}
