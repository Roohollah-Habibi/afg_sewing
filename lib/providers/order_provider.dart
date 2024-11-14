import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final _registerDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
final Box _swingBox = Hive.box('SwingDb');
final List<Customer> _customers =
    _swingBox.values.whereType<Customer>().cast<Customer>().toList();

class OrderProvider extends ChangeNotifier {


  DateTime? _deadline;
  DateTime _registerDate = DateFormat('yyyy-MM-dd').parse(_registerDateStr);

  int _remainingPrice = 0;

// GETTERS ===================================================
  int get getRemainingPrice => _remainingPrice;


  String get getRegisterDate =>
      '${_registerDate.day}-${_registerDate.month}-${_registerDate.year}';
DateTime? get getDeadline => _deadline;

  // METHODS ========================================================================


}
