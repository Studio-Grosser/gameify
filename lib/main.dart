import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gameify/pages/main_page.dart';
import 'package:gameify/utils/theme_provider.dart';
import 'package:gameify/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn =
        'https://3d9bef32669962b5e14f7492d77a82e7@o4506547353681920.ingest.us.sentry.io/4508109601636352';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1.0;
    // The sampling rate for profiling is relative to tracesSampleRate
    // Setting to 1.0 will profile 100% of sampled transactions:
    options.profilesSampleRate = 1.0;
  },
      appRunner: () => runApp(ChangeNotifierProvider(
          create: (context) => ThemeProvider(), child: const MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gameify',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      home: const MainPage(),
    );
  }
}
