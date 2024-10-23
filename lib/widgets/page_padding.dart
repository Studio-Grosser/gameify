import 'package:flutter/cupertino.dart';
import 'package:gameify/utils/responsive_utils.dart';

/// Default Widget for adding padding to pages. Should be used near root
/// after Scaffold, before actually page content (e.g column).
/// Adjusts padding based on screen width. For tablets, the screen
/// padding is doubled.
class PagePadding extends StatelessWidget {
  const PagePadding({super.key, required this.padding, required this.child});
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    double left = responsiveScreenPadding(padding.left, context);
    double right = responsiveScreenPadding(padding.right, context);
    double top = responsiveScreenPadding(padding.top, context);
    double bottom = responsiveScreenPadding(padding.bottom, context);
    EdgeInsets screenPadding = EdgeInsets.fromLTRB(left, top, right, bottom);
    return Padding(padding: screenPadding, child: child);
  }
}
