import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/widgets/styled_container.dart';

class MetricDisplay extends StatelessWidget {
  const MetricDisplay({super.key, required this.metric, required this.unit});
  final String metric;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StyledContainer(
        padding: const EdgeInsets.all(15),
        hideBorder: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(metric, style: Font.h2),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, bottom: 4.0),
                child:
                    Text(unit, style: Font.b1, overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
