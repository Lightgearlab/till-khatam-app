import 'package:flutter/material.dart';
import 'package:tillkhatam/core/app_color.dart';

class AppTheme {
  static ThemeData hafizTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.lightGreen,
    colorScheme: const ColorScheme.light(
        primary: AppColor.lightGreen, error: AppColor.lightPink),
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontFamily: "Roboto", color: AppColor.lightGreen),
      bodyMedium: TextStyle(fontFamily: "Roboto", color: AppColor.lightGreen),
      bodyLarge: TextStyle(fontFamily: "Roboto", color: AppColor.lightGreen),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.lightGreen,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static ThemeData sakinahTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColor.lightPink,
    colorScheme: const ColorScheme.light(
        primary: AppColor.lightPink, error: AppColor.lightGreen),
    textTheme: const TextTheme(
      bodySmall: TextStyle(fontFamily: "Roboto", color: AppColor.lightPink),
      bodyMedium: TextStyle(fontFamily: "Roboto", color: AppColor.lightPink),
      bodyLarge: TextStyle(fontFamily: "Roboto", color: AppColor.lightPink),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.lightGreen,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
  const AppTheme._();
}
