import 'package:flutter/material.dart';
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
        showBorder: true,
        borderRadius: 25,
        width: 45,
        height: 45,
        child: Center(child: Icon(icon, size: 20)),
      ),
    );
  }
}
