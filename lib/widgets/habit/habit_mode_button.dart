import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/models/habit_mode.dart';
import 'package:gameify/widgets/habit/habit_option.dart';
import 'package:gameify/widgets/styled/styled_container.dart';

class HabitModeButton extends StatefulWidget {
  const HabitModeButton(
      {super.key,
      required this.currentHabitMode,
      required this.jumpScale,
      required this.animationDuration,
      required this.onTap});
  final HabitMode currentHabitMode;
  final double jumpScale;
  final Duration animationDuration;
  final VoidCallback onTap;

  @override
  State<HabitModeButton> createState() => _HabitModeButtonState();
}

class _HabitModeButtonState extends State<HabitModeButton> {
  Timer? timer;
  double infoOpacity = 0;
  static const Duration _infoFadeDuration = Duration(milliseconds: 200);
  static const Duration _infoDuration = Duration(milliseconds: 1500);

  void showHabitName() {
    setState(() {
      infoOpacity = 1;
    });
    timer?.cancel();
    timer = Timer(_infoDuration, () {
      setState(() {
        timer = null;
        infoOpacity = 0;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: -55,
            child: AnimatedOpacity(
              opacity: infoOpacity,
              duration: _infoFadeDuration,
              child: StyledContainer(
                child: Text(
                  widget.currentHabitMode.name,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          HabitOption(
            onTap: () {
              showHabitName();
              widget.onTap();
            },
            jumpScale: widget.jumpScale,
            animationDuration: widget.animationDuration,
            child: Center(
              child: FaIcon(widget.currentHabitMode.icon, size: 30),
            ),
          )
        ]);
  }
}
