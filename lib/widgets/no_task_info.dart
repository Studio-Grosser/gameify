import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';

class NoTaskInfo extends StatelessWidget {
  const NoTaskInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const FaIcon(FontAwesomeIcons.folderOpen,
          size: 20, color: Themes.secondary),
      const SizedBox(height: 10),
      Text('no tasks yet', style: Font.b1.copyWith(color: Themes.secondary)),
    ]));
  }
}
