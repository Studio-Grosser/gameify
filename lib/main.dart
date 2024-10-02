import 'package:flutter/material.dart';
import 'package:gameify/pages/main_page.dart';
import 'package:gameify/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Themes.lightTheme,
      home: const MainPage(),
    );
  }
}
