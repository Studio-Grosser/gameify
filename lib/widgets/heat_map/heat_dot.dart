import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';

class HeatDot extends StatelessWidget {
  const HeatDot({
    super.key,
    required this.size,
    required this.heatFactor,
    required this.isCurrentDate,
  });
  final double size;
  final double heatFactor;
  final bool isCurrentDate;
  Color? get colorVariant {
    if (heatFactor > 0) {
      return Themes.success.withValues(alpha: heatFactor);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colorVariant ?? theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(size / 4),
        border: isCurrentDate
            ? Border.all(width: 2, color: theme.colorScheme.secondary)
            : null,
      ),
    );
  }
}
