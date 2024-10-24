import 'package:flutter/material.dart';

class Themes {
  static const String fontFamily = 'Figtree';

  static const Color shade1 = Color(0xffFFFFFF); //White Mode BG
  static const Color shade2 = Color(0xffFAFAFA);
  static const Color shade3 = Color(0xffF0F0F0);
  static const Color shade4 = Color(0xffDCDCDC);
  static const Color shade5 = Color(0xff4C4C4C);
  static const Color shade6 = Color(0xff1E1E1E); //Dark Mode BG
  static const Color shade7 = Color(0xff121212);

  static const Color accent = Color(0xff4790FD);
  static const Color success = Color(0xff05C46B);
  static const Color danger = Color(0xffF53B57);

  static ThemeData lightTheme = ThemeData(
      drawerTheme: const DrawerThemeData(backgroundColor: shade1),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: shade4, backgroundColor: shade1),
      iconTheme: const IconThemeData(color: shade7),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: shade5, width: 2),
        fillColor: const WidgetStateProperty.fromMap(
          {WidgetState.selected: shade5},
        ),
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: shade1,
      colorScheme: const ColorScheme.light(
        primaryContainer: shade2,
        onPrimaryContainer: shade4,
        secondaryContainer: shade3,
        primary: accent,
        secondary: shade4,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: shade5,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
            fontFamily: fontFamily,
            fontWeight: FontWeight.w500,
            color: shade5,
            fontSize: 14),
        titleMedium: TextStyle(
          color: shade5,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 28,
          height: 1,
        ),
        titleLarge: TextStyle(
          color: shade5,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 36,
        ),
      ));

  static ThemeData darkTheme = ThemeData(
      drawerTheme: const DrawerThemeData(backgroundColor: shade6),
      bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: shade5, backgroundColor: shade6),
      iconTheme: const IconThemeData(color: shade4),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        side: const BorderSide(color: shade4, width: 2),
        fillColor: const WidgetStateProperty.fromMap(
          {WidgetState.selected: shade4},
        ),
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: shade6,
      colorScheme: const ColorScheme.dark(
        primaryContainer: shade7,
        onPrimaryContainer: shade5,
        secondaryContainer: shade6,
        primary: accent,
        secondary: shade5,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          color: shade4,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        bodyMedium: TextStyle(
          color: shade4,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        titleMedium: TextStyle(
          color: shade4,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 28,
          height: 1,
        ),
        titleLarge: TextStyle(
          color: shade4,
          fontFamily: fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 36,
        ),
      ));
}
