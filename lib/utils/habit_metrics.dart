import 'package:flutter/material.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/utils/logger.dart';

class HabitMetrics {
  int highscore = 0;
  int average = 0;
  bool brokeHighscore = false;

  void refreshMetrics(List<Date> allDates, VoidCallback newHighscoreCallback) {
    final scores = allDates.map((date) => date.score);
    if (scores.isNotEmpty) {
      final sum = scores.reduce((a, b) => a + b);
      int newHighscore =
          scores.reduce((current, next) => current > next ? current : next);

      if (newHighscore > highscore && highscore != 0 && !brokeHighscore) {
        Logger.i('New highscore: $newHighscore');
        newHighscoreCallback();
        brokeHighscore = true;
      }

      highscore = newHighscore;

      average = sum ~/ scores.length;
    }
  }
}
