import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameify/database/database_service.dart';
import 'package:gameify/utils/dialog_utils.dart';
import 'package:gameify/utils/logger.dart';
import 'package:gameify/utils/theme_provider.dart';
import 'package:gameify/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';

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
    if (kReleaseMode) {
      Logger.i('Restarting App');
      Restart.restartApp(
        notificationTitle: 'Restarting App',
        notificationBody: 'Please tap here to open the app again.',
      );
    }
  }

  Future<void> openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Drawer(
      child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            onTap: () =>
                openLink('https://studiogrosser.com/legal-notice.html'),
            leading: const Icon(CupertinoIcons.lock, size: 18),
            title: Text('settings.privacy'.tr(),
                style: theme.textTheme.bodyMedium),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            onTap: () {
              setState(() {
                themeProvider.toggleThemeMode();
              });
            },
            leading: Icon(themeProvider.themeIcon, size: 18),
            title: Text(themeProvider.themeDescription,
                style: theme.textTheme.bodyMedium),
          ),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 35),
            onTap: resetApp,
            leading: const Icon(
              CupertinoIcons.trash,
              color: Themes.danger,
              size: 18,
            ),
            title: Text(
              'settings.reset'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(color: Themes.danger),
            ),
          ),
        ]),
      ),
    );
  }
}
