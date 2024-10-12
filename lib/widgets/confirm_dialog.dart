import 'package:flutter/material.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/widgets/styled_button.dart';
import 'package:gap/gap.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.confirmText,
      required this.cancelText,
      this.body});
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Widget? body;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: theme.textTheme.bodyLarge),
            Text(message, style: theme.textTheme.bodyMedium),
            const Gap(50),
            if (body != null) body!,
            const Gap(50),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              StyledButton(
                color: Colors.transparent,
                textColor: theme.colorScheme.onPrimaryContainer,
                text: cancelText,
                onTap: () => Navigator.pop(context, false),
              ),
              const SizedBox(width: 15),
              StyledButton(
                color: Themes.danger,
                textColor: Themes.shade1,
                text: confirmText,
                onTap: () => Navigator.pop(context, true),
              ),
            ]),
          ])),
    );
  }
}
