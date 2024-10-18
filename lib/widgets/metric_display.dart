import 'package:flutter/material.dart';
import 'package:gameify/widgets/styled_container.dart';

class MetricDisplay extends StatelessWidget {
  const MetricDisplay({super.key, this.metric, required this.unit});
  final Future<num?>? metric;
  final String unit;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Expanded(
      child: StyledContainer(
        height: 65,
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FutureBuilder(
                future: metric,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator.adaptive();
                  }
                  int? value = (snapshot.data)?.toInt();
                  return Text('$value', style: theme.textTheme.titleMedium);
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(unit,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
