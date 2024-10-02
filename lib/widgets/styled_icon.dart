import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/widgets/styled_container.dart';

class StyledIcon extends StatelessWidget {
  const StyledIcon({super.key, required this.icon, this.onTap});
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: StyledContainer(
        borderRadius: 25,
        width: 50,
        height: 50,
        child: FaIcon(icon),
      ),
    );
  }
}
