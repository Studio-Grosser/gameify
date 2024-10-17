import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';

class HeatDot extends StatelessWidget {
  const HeatDot({
    super.key,
    required this.size,
    required this.heatFactor,
  });
  final double size;
  final double heatFactor;

  Color? get colorVariant {
    if (heatFactor > 0) {
      return Themes.success.withValues(alpha: heatFactor);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorVariant ?? theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
      ),
    );
  }
}
