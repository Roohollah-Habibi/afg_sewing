import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/models_and_List/settings.dart';
import 'package:flutter/material.dart';

class SettingProvider extends ChangeNotifier{
  Settings _settings = Constants.swingBox.get('lang') as Settings? ?? Settings(appLanguages: AppLanguage.english);
  Settings get getSettings => _settings;

  void changeLanguage(AppLanguage newLanguage) async{
    _settings = _settings.copyWith(newLanguage: newLanguage);
    notifyListeners();
    await Constants.swingBox.put('lang', _settings);
  }
}