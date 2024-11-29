import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'constants.g.dart';

@HiveType(typeId: 3)
enum AppLanguage { @HiveField(0)english, @HiveField(1)persian, @HiveField(2)pashto }

class Constants{
  static final Box swingBox = Hive.box('SwingDb');
  static const fieldKeyForName = 'name';
  static const fieldKeyForLast = 'last';
  static const fieldKeyForPhone = 'phone';
  static final DateTime todayAsDate = formatMyDate(myDate: DateTime.now()) as DateTime;
  static final String todayAsString = formatMyDate(myDate: DateTime.now(),returnAsDate: false) as String;

  /// This method is responsible for getting a date and return a formatted date[ as date or string] just to make the future codes more cleaner LIKE
  /// 2024-01-21 - 00:00:00
  static dynamic formatMyDate({required DateTime? myDate, bool returnAsDate = true}) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(myDate!);
    DateTime myTime = DateFormat('yyyy-MM-dd').parse(dateStr);
    return returnAsDate ? myTime : '${myTime.day}-${myTime.month}-${myTime.year}';
  }
}