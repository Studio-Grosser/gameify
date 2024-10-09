import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';

class StyledButton extends StatelessWidget {
  const StyledButton(
      {super.key,
      required this.text,
      required this.color,
      required this.textColor,
      this.enabled = true,
      required this.onTap});
  final String text;
  final Color color;
  final Color textColor;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(10)),
          child: Text(text, style: Font.h3.copyWith(color: textColor))),
    );
  }
}
