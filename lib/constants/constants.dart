import 'package:hive/hive.dart';

class Constants{
  static final Box swingBox = Hive.box('SwingDb');
  static const fieldKeyForName = 'name';
  static const fieldKeyForLast = 'last';
  static const fieldKeyForPhone = 'phone';
}