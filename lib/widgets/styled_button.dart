import 'package:flutter/material.dart';

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
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12)),
          child: Text(text,
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor))),
    );
  }
}
