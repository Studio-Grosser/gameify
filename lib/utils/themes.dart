import 'package:flutter/material.dart';

class Themes {
  static const Color primary = Color(0xff4C4C4C);
  static const Color secondary = Color(0xffF0F0F0);
  static const Color tertiary = Color(0xffFBFBFB);
  static const Color surface = Color(0xffFFFFFF);

  static const Color success = Color(0xff2ED573);
  static const Color warning = Color(0xffFF4757);
  static const Color accent = Color(0xff4790FD);

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.light(
        primary: accent,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Figtree',
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1,
          fontSize: 18,
        ),
      ));
}
