import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';

class StyledContainer extends StatelessWidget {
  const StyledContainer(
      {super.key,
      required this.child,
      this.borderRadius = 15,
      this.padding = const EdgeInsets.all(10),
      this.margin = const EdgeInsets.all(2),
      this.height,
      this.width,
      this.hideBorder = false});
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final bool hideBorder;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          border: Border.all(
              width: 2,
              color: hideBorder ? Colors.transparent : Themes.secondary),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: child);
  }
}
