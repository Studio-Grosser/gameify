import 'package:flutter/material.dart';
import 'package:gameify/widgets/styled/styled_container.dart';

class HabitOption extends StatelessWidget {
  const HabitOption(
      {super.key,
      required this.onTap,
      required this.jumpScale,
      required this.animationDuration,
      required this.child});
  final VoidCallback onTap;
  final double jumpScale;
  final Duration animationDuration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: StyledContainer(
          showBorder: true,
          height: 70,
          width: 70,
          borderRadius: 50,
          padding: const EdgeInsets.all(16),
          child: AnimatedScale(
              scale: jumpScale,
              duration: animationDuration,
              curve: Curves.linear,
              child: child)),
    );
  }
}
