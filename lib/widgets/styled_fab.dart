import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/themes.dart';

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

  Widget get iconWidget => FaIcon(icon, color: Themes.surface, size: 18);

  @override
  Widget build(BuildContext context) {
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Themes.surface)),
                  const SizedBox(width: 15),
                ],
                iconWidget
              ],
            )));
  }
}
