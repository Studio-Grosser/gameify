import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gameify/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _storeKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isLightTheme => themeMode == ThemeMode.light;

  String get themeDescription =>
      ['System Mode', 'Light Mode', 'Dark Mode'][themeMode.index];

  IconData get themeIcon => [
        FontAwesomeIcons.lightbulb,
        FontAwesomeIcons.sun,
        FontAwesomeIcons.moon
      ][themeMode.index];

  set themeMode(ThemeMode themeData) {
    _themeMode = themeData;
    notifyListeners();
  }

  void initializeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeMode.values[prefs.getInt(_storeKey) ?? 0];
    Logger.s('Set theme mode to: "$themeMode"');
    notifyListeners();
  }

  void saveThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_storeKey, themeMode.index);
    Logger.s('Saved theme mode: "$themeMode" to shared preferences');
  }

  void toggleThemeMode() {
    themeMode =
        ThemeMode.values[(themeMode.index + 1) % ThemeMode.values.length];
    saveThemeMode(themeMode);
    notifyListeners();
  }
}
