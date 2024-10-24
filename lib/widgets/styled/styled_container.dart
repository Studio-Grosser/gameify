import 'package:flutter/material.dart';

class StyledContainer extends StatelessWidget {
  const StyledContainer(
      {super.key,
      required this.child,
      this.borderRadius = 15,
      this.padding = const EdgeInsets.all(10),
      this.margin = const EdgeInsets.all(2),
      this.height,
      this.width,
      this.showBorder = false,
      this.color});
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool showBorder;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? colorScheme.primaryContainer,
          border: Border.all(
              width: 2,
              color: showBorder
                  ? colorScheme.secondaryContainer
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child);
  }
}
