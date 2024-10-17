import 'package:flutter/cupertino.dart';
import 'package:gameify/utils/utils.dart';
import 'package:gameify/widgets/heat_map/heat_dot.dart';
import 'package:gameify/widgets/styled_container.dart';

class HeatMap extends StatelessWidget {
  const HeatMap({super.key, required this.data});
  final Map<DateTime, double> data;

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
      (int, int) calculatedDots = _calculateDots(constaints.maxWidth);
      int dotCount = calculatedDots.$1;
      int dotsInRow = calculatedDots.$2;

      return StyledContainer(
          padding: const EdgeInsets.symmetric(
              vertical: _padding, horizontal: _padding),
          hideBorder: true,
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

                double heatFactor = 0;
                if (data.containsKey(date)) {
                  heatFactor = data[date]!;
                }
                return HeatDot(size: _dotSize, heatFactor: heatFactor);
              }),
            ),
          ));
    });
  }
}
