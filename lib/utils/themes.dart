import 'package:flutter/material.dart';

class Themes {
  static const Color primary = Color(0xff2D3436);
  static const Color secondary = Color(0xffD9D9D9);
  static const Color tertiary = Color(0xffECF0F1);
  static const Color surface = Color(0xffFFFFFF);

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        surface: surface,
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1,
          fontSize: 13,
        ),
      ));
}
