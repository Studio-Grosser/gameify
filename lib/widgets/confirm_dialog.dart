import 'package:flutter/cupertino.dart';
import 'package:gameify/utils/font.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_button.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.confirmText,
      required this.cancelText,
      required this.body});
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: Font.h3),
            const SizedBox(height: 10),
            Text(message, style: Font.b1),
            const SizedBox(height: 40),
            body,
            const SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              StyledButton(
                color: Themes.secondary,
                textColor: Themes.primary,
                text: cancelText,
                onTap: () => Navigator.pop(context, false),
              ),
              const SizedBox(width: 15),
              StyledButton(
                color: Themes.warning,
                textColor: Themes.surface,
                text: confirmText,
                onTap: () => Navigator.pop(context, true),
              ),
            ]),
          ])),
    );
  }
}
