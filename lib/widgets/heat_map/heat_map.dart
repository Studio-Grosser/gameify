import 'package:flutter/cupertino.dart';
import 'package:gameify/models/date.dart';
import 'package:gameify/models/heat_dot_animation.dart';
import 'package:gameify/utils/date_utils.dart';
import 'package:gameify/utils/habit_manager.dart';
import 'package:gameify/widgets/heat_map/heat_dot.dart';
import 'package:gameify/widgets/styled/styled_container.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class HeatMap extends StatelessWidget {
  const HeatMap({super.key, required this.dates, required this.currentDate});
  final List<Date> dates;
  final DateTime currentDate;

  static const _dotSize = 20.0;
  static const _dotMargin = 2.5;
  static const _columns = 3;
  static const _padding = 10.0;

  static const _maxScale = 1.5;
  static const _beginScale = 1;
  static const _maxDistanceAnimation = 8;

  static (int, int) _calculateDots(double containerWidth) {
    int dotsInRow = (containerWidth / (_dotSize + _dotMargin)).toInt();
    int dotCount = dotsInRow * _columns - 1;
    return (dotCount, dotsInRow);
  }

  static final DateTime _now = DateTime.now().startOfDay;

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitManager>(builder: (context, habitManager, child) {
      return StyledContainer(
          padding: const EdgeInsets.symmetric(
              vertical: _padding, horizontal: _padding),
          child: LayoutBuilder(builder: (context, constraints) {
            int highscore = 0;
            if (dates.isNotEmpty) {
              highscore = dates.reduce((current, next) {
                return current.score > next.score ? current : next;
              }).score;
            }

            (int, int) calculatedDots = _calculateDots(constraints.maxWidth);
            int dotCount = calculatedDots.$1;
            int dotsInRow = calculatedDots.$2;

            return Center(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: _dotMargin,
                runSpacing: _dotMargin,
                children: List.generate(dotCount, (index) {
                  int verticalIndex =
                      ((index % dotsInRow) * _columns) + (index ~/ dotsInRow);

                  DateTime date = _now
                      .subtract(Duration(days: dotCount - (verticalIndex + 1)));

                  int score = dates
                          .firstWhereOrNull((d) => date.toId() == d.id)
                          ?.score ??
                      0;

                  int distance = currentDate.difference(date).inDays.abs() ~/ 3;

                  double heatFactor = highscore > 0 ? score / highscore : 0;
                  return HeatDot(
                    size: _dotSize,
                    heatFactor: heatFactor,
                    isCurrentDate: date == currentDate,
                    controller: (tickerProvider) {
                      AnimationController controller = AnimationController(
                          vsync: tickerProvider,
                          duration: const Duration(milliseconds: 200));

                      double endScale = _maxScale -
                          ((_maxScale - _beginScale) / _maxDistanceAnimation) *
                              distance;
                      endScale =
                          endScale.clamp(_beginScale.toDouble(), _maxScale);
                      Animation animation =
                          Tween<double>(begin: 1, end: endScale)
                              .animate(CurvedAnimation(
                        parent: controller,
                        curve: Curves.easeInOut,
                      ));
                      habitManager.heatDotAnimations[index] = HeatDotAnimation(
                        distance.toDouble(),
                        controller,
                      );
                      return animation;
                    },
                  );
                }),
              ),
            );
          }));
    });
  }
}
