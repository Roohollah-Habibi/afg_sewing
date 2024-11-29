import 'package:afg_sewing/constants/constants.dart';
import 'package:hive_flutter/adapters.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class Settings extends HiveObject{
  @HiveField(0)
  final AppLanguage appLanguages;

  Settings({required this.appLanguages });

  Settings copyWith({AppLanguage? newLanguage}){
    return Settings(appLanguages: newLanguage ?? appLanguages);
  }

}