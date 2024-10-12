import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/utils/logger.dart';
import 'package:gameify/utils/theme_provider.dart';
import 'package:gameify/utils/themes.dart';
import 'package:gameify/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class SettingsDrawer extends StatefulWidget {
  const SettingsDrawer({super.key});

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  Future<void> resetApp() async {
    bool confirmed = await confirmReset(context);
    if (!mounted || !confirmed) return;
    await DatabaseService.instance.delteDb();
    Logger.i('Restarting App');
    Restart.restartApp(
      notificationTitle: 'Restarting App',
      notificationBody: 'Please tap here to open the app again.',
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            ListTile(
              onTap: () {
                setState(() {
                  themeProvider.toggleThemeMode();
                });
              },
              leading: FaIcon(themeProvider.themeIcon),
              title: Text(themeProvider.themeDescription,
                  style: theme.textTheme.bodyLarge),
            ),
            ListTile(
              onTap: resetApp,
              leading:
                  const FaIcon(FontAwesomeIcons.trashCan, color: Themes.danger),
              title: Text(
                'Reset App',
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: Themes.danger),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
