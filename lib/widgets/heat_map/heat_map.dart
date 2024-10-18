import 'package:flutter/cupertino.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gameify/widgets/heat_map/heat_dot.dart';
import 'package:gameify/widgets/styled_container.dart';
import 'package:collection/collection.dart';

class HeatMap extends StatelessWidget {
  const HeatMap({super.key, required this.dates, required this.currentDate});
  final List<Date> dates;
  final DateTime currentDate;

  static const _dotSize = 20.0;
  static const _dotMargin = 2.5;
  static const _columns = 3;
  static const _padding = 10.0;

  static (int, int) _calculateDots(double containerWidth) {
    double effectiveWidth = containerWidth - (2 * _padding);
    int dotsInRow = (effectiveWidth / (_dotSize + _dotMargin)).toInt();
    int dotCount = dotsInRow * _columns - 1;
    return (dotCount, dotsInRow);
  }

  static final DateTime _now = DateTime.now().startOfDay;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constaints) {
      int highscore = 0;
      if (dates.isNotEmpty) {
        highscore = dates.reduce((current, next) {
          return current.score > next.score ? current : next;
        }).score;
      }

      (int, int) calculatedDots = _calculateDots(constaints.maxWidth);
      int dotCount = calculatedDots.$1;
      int dotsInRow = calculatedDots.$2;

      return StyledContainer(
          padding: const EdgeInsets.symmetric(
              vertical: _padding, horizontal: _padding),
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: _dotMargin,
              runSpacing: _dotMargin,
              children: List.generate(dotCount, (index) {
                int verticalIndex =
                    ((index % dotsInRow) * _columns) + (index ~/ dotsInRow);

                DateTime date = _now
                    .subtract(Duration(days: dotCount - (verticalIndex + 1)));

                int score =
                    dates.firstWhereOrNull((d) => date.toId() == d.id)?.score ??
                        0;

                double heatFactor = highscore > 0 ? score / highscore : 0;
                return HeatDot(
                    size: _dotSize,
                    heatFactor: heatFactor,
                    isCurrentDate: date == currentDate);
              }),
            ),
          ));
    });
  }
}
