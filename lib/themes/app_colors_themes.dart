import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColorsAndThemes {
  static const primaryColor = Color.fromRGBO(243, 243, 224, 1);
  static const subPrimaryColor = Color.fromRGBO(199, 203, 208, 1.0);
  static const secondaryColor = Color.fromARGB(255, 19, 62, 135);
  static const accentColor = Color.fromARGB(255, 72, 98, 203);
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
  scaffoldBackgroundColor: AppColorsAndThemes.subPrimaryColor,
  snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColorsAndThemes.secondaryColor,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      width: 370,
      showCloseIcon: true,
      closeIconColor: AppColorsAndThemes.primaryColor,
      insetPadding: EdgeInsets.only(bottom: 37),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      )),
  listTileTheme: const ListTileThemeData(
    tileColor: AppColorsAndThemes.subPrimaryColor,
  ),
  dividerTheme: const DividerThemeData(
      color: AppColorsAndThemes.secondaryColor,
      thickness: 1.1,
      endIndent: 10,
      indent: 10),
  popupMenuTheme: const PopupMenuThemeData(
      color: AppColorsAndThemes.subPrimaryColor,
      shadowColor: AppColorsAndThemes.secondaryColor,
      elevation: 5),

  dialogTheme: const DialogTheme(
    backgroundColor: AppColorsAndThemes.subPrimaryColor,
    elevation: 5,
    shadowColor: AppColorsAndThemes.secondaryColor,
    alignment: Alignment.center,

  ),
  primaryTextTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 27)),
  bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColorsAndThemes.subPrimaryColor),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColorsAndThemes.secondaryColor,
    foregroundColor: AppColorsAndThemes.primaryColor,
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(AppColorsAndThemes.accentColor),
      iconSize: WidgetStatePropertyAll(30),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColorsAndThemes.accentColor),
      ),
    ),
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
      iconColor: WidgetStatePropertyAll<Color>(AppColorsAndThemes.primaryColor),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColorsAndThemes.secondaryColor,
    foregroundColor: AppColorsAndThemes.primaryColor,
  ),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: AppColorsAndThemes.secondaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 25),
  bodyMedium: TextStyle(fontSize: 18)),
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
  primaryTextTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 27)),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: AppColorsAndThemes.darkOptionalColor,
          fontWeight: FontWeight.bold,
          fontSize: 25)),
);
