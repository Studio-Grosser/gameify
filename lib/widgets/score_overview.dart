import 'package:flutter/material.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:gameify/widgets/score_display.dart';

class ScoreOverview extends StatelessWidget {
  const ScoreOverview(
      {super.key,
      required this.score,
      required this.negativeScore,
      required this.positiveScore});
  final int score;
  final int negativeScore;
  final int positiveScore;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return StyledContainer(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ScoreDisplay(value: negativeScore, isDefaultNegative: true),
            Text(score.toString(), style: theme.textTheme.titleLarge),
            ScoreDisplay(value: positiveScore),
          ],
        ));
  }
}
