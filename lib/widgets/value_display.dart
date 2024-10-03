import 'package:flutter/material.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';

class ValueDisplay extends StatelessWidget {
  const ValueDisplay({super.key, required this.value});
  final int value;

  Color get color => value >= 0 ? Themes.success : Themes.warning;
  String get text => value >= 0 ? '+$value' : '$value';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: Center(
            child: Text(text, style: Font.b1.copyWith(color: Themes.surface))));
  }
}
