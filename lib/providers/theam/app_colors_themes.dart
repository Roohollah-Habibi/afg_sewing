import 'package:flutter/material.dart';

class AppColorsAndThemes {
  static const primaryColor = Color.fromRGBO(243, 243, 224, 1);
  static const secondaryColor = Color.fromARGB(255, 19, 62, 135);
  static const accentColor = Color.fromARGB(255, 96, 139, 193);
  static const optional = Color.fromARGB(255, 203, 220, 235);

  static const darkPrimaryColor = Color.fromRGBO(54, 48, 98, 1);
  static const darkSecondaryColor = Color.fromARGB(255, 67, 85, 133);
  static const darkAccentColor = Color.fromARGB(255, 129, 143, 180);
  static const darkOptionalColor = Color.fromARGB(255, 245, 232, 199);
}

ThemeData myLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsAndThemes.primaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsAndThemes.secondaryColor,
      // Use only backgroundColor
      foregroundColor: AppColorsAndThemes.primaryColor, // For text and icons
    ),
    fontFamily: 'roboto',
    fontFamilyFallback: const [
      'Arial', // Generic fallback
      'Sans-serif',
    ],
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll<Color?>(AppColorsAndThemes.secondaryColor),
        foregroundColor:
            WidgetStatePropertyAll<Color>(AppColorsAndThemes.primaryColor),
        iconColor:
            WidgetStatePropertyAll<Color>(AppColorsAndThemes.primaryColor),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColorsAndThemes.secondaryColor,
      foregroundColor: AppColorsAndThemes.primaryColor,
    ),
  textTheme : const TextTheme(
      titleLarge: TextStyle(
          color: AppColorsAndThemes.secondaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 25)),
);









// DARK THEME
ThemeData myDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsAndThemes.darkPrimaryColor,
      brightness: Brightness.dark),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
      WidgetStatePropertyAll<Color?>(AppColorsAndThemes.darkPrimaryColor),
      foregroundColor:
      WidgetStatePropertyAll<Color>(AppColorsAndThemes.darkOptionalColor),
      iconColor:
      WidgetStatePropertyAll<Color>(AppColorsAndThemes.darkOptionalColor),
    ),
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: AppColorsAndThemes.darkPrimaryColor,
      foregroundColor: AppColorsAndThemes.darkOptionalColor),
    textTheme : const TextTheme(
    titleLarge: TextStyle(
        color: AppColorsAndThemes.darkOptionalColor,
        fontWeight: FontWeight.bold,
        fontSize: 25)),
);
