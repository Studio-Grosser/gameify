import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gap/gap.dart';

class StyledFab extends StatelessWidget {
  const StyledFab(
      {super.key,
      required this.icon,
      this.text,
      this.onTap,
      this.height,
      this.width,
      this.padding = const EdgeInsets.symmetric(vertical: 25, horizontal: 35)});
  final IconData icon;
  final String? text;
  final Function()? onTap;
  final double? height;
  final double? width;
  final EdgeInsets padding;

  Widget get iconWidget => Icon(icon, color: Themes.shade1, size: 24);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: height,
            width: width,
            padding: padding,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: Themes.accent.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10))
                ]),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (text != null) ...[
                  Text(text!,
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: Themes.shade1)),
                  const Gap(15)
                ],
                iconWidget
              ],
            )));
  }
}
