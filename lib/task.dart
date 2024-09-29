import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String name;
  final int score;

  Task({required this.name, required this.score}) : id = const Uuid().v1();
}
