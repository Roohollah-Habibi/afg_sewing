
import 'package:flutter/material.dart';

class ThemeManagerProvider extends ChangeNotifier{

  ThemeMode _themeMode = ThemeMode.light;

  get themeMode => _themeMode;

  switchTheme(bool isDarkMode){
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

}