import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';

class HeatDot extends StatefulWidget {
  const HeatDot({
    super.key,
    required this.size,
    required this.heatFactor,
    required this.isCurrentDate,
    required this.animation,
  });
  final double size;
  final double heatFactor;
  final bool isCurrentDate;
  final Animation<double> Function(TickerProvider) animation;

  @override
  State<HeatDot> createState() => _HeatDotState();
}

class _HeatDotState extends State<HeatDot> with TickerProviderStateMixin {
  Color? get colorVariant {
    if (widget.heatFactor > 0) {
      return Themes.success.withValues(alpha: widget.heatFactor);
    }
    return null;
  }

  late Animation animation;

  @override
  void initState() {
    animation = widget.animation(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: animation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: colorVariant ?? theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(widget.size / 4),
                border: widget.isCurrentDate
                    ? Border.all(width: 2, color: theme.colorScheme.secondary)
                    : null,
              ),
            ),
          );
        });
  }
}
