import 'package:gameify/models/date.dart';

class HabitMetrics {
  int highscore = 0;
  int average = 0;

  void refreshMetrics(List<Date> allDates) {
    final scores = allDates.map((date) => date.score);
    if (scores.isNotEmpty) {
      final sum = scores.reduce((a, b) => a + b);
      highscore =
          scores.reduce((current, next) => current > next ? current : next);
      average = sum ~/ scores.length;
    }
  }
}
