import 'package:flutter/material.dart';
import 'package:gameify/pages/main_page.dart';
import 'package:gameify/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gameify',
      theme: Themes.lightTheme,
      home: const MainPage(),
    );
  }
}
