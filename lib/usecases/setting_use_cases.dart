import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/providers/setting_provider.dart';

class SettingUseCases{
  final SettingProvider _settingProvider;

  SettingUseCases(this._settingProvider);

  void call(AppLanguage newLanguage) async{
    _settingProvider.changeLanguage(newLanguage);
  }

}