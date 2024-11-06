import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final _registerDateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
final Box _swingBox = Hive.box('SwingDb');

class OrderProvider extends ChangeNotifier {
  static int _orderIdNew = (_swingBox.get('oi') as int?) ?? 0;
  List<Customer> customers =
      _swingBox.values.whereType<Customer>().cast<Customer>().toList();
  int _remainingPrice = 0;
  DateTime? _deadline;
  DateTime _registerDate = DateFormat('yyyy-MM-dd').parse(_registerDateStr);

// GETTERS ===================================================
  int get getRemainingPrice => _remainingPrice;

  String get getRegisterDate =>
      '${_registerDate.day}-${_registerDate.month}-${_registerDate.year}';

  String get getDeadline =>
      '${_deadline?.day}-${_deadline?.month}-${_deadline?.year}';

  // METHODS ======================================================
  /*
final foundOrder = customer.customerOrder.firstWhere( (foundOrder) => foundOrder.id == orderId, orElse: () => null, );
   */
  Order? order({required String customerId, required String orderId}) {
    final targetCustomer =
        customers.firstWhere((foundCustomer) => foundCustomer.id == customerId);
    return targetCustomer.customerOrder.firstWhere(
        (foundOrder) => foundOrder.id == orderId);
    notifyListeners();
  }

// setting remaining money
  int setRemainingPrice(double total, double received) {
    return _remainingPrice = total.toInt() - received.toInt();
  }

// pick register date
  Future<void> pickRegisterDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _registerDate = pickedDate;
      notifyListeners();
    }
  }

  // pick deadline
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _deadline = pickedDate;
      notifyListeners();
    }
  }

// saving new Order
  Future<void> addNewOrder(
      {required BuildContext context,
      required Map<String, String> orderInfo,
      required Customer customer,
      required String orderId}) async {
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 600),
        content: Text('Pick a deadline date'),
      ));
      return;
    }
    print('++++++++++++++++++ ${orderInfo}');
    double total = double.tryParse(orderInfo['total'] as String) ?? 0;
    double received = double.tryParse(orderInfo['received'] as String) ?? 0;
    final String deadLineStr = DateFormat('yyyy-MM-dd').format(_deadline!);
    _deadline = DateFormat('yyyy-MM-dd').parse(deadLineStr);
    final Order newOrder = Order(
      customerId: customer.id,
      id: orderId.isEmpty ? '${_orderIdNew++}'.toString() : orderId,
      isDone: false,
      isDelivered: false,
      registeredDate: _registerDate,
      deadLineDate: _deadline!,
      qad: orderInfo['ghad'] as String,
      shana: orderInfo['shane'] as String,
      astinSada: orderInfo['astinSade'] as String,
      astinKaf: orderInfo['astinKaf'] as String,
      yeqa: orderInfo['yeghe'] as String,
      beghal: orderInfo['baghal'] as String,
      shalwar: orderInfo['shalwar'] as String,
      parcha: orderInfo['parche'] as String,
      qout: orderInfo['ghot'] as String,
      damAstin: orderInfo['damAstin'] as String,
      barAstin: orderInfo['barAstin'] as String,
      jibShalwar: orderInfo['jibShalwar'] as String,
      qadPuti: orderInfo['qhadPuti'] as String,
      barShalwar: orderInfo['barShalwar'] as String,
      faq: orderInfo['fagh'] as String,
      doorezano: orderInfo['doorezano'] as String,
      kaf: orderInfo['kaf'] as String,
      jibRoo: orderInfo['jibroo'] as String,
      damanRast: orderInfo['damanRast'] as String,
      damanGerd: orderInfo['damanGerd'] as String,
      model: orderInfo['model'] as String,
      totalCost: total.toInt(),
      receivedMoney: received.toInt(),
      remainingMoney: setRemainingPrice(total, received),
    );
    await Customer.addNewOrder(
        newOrder: newOrder, customerId: customer.id, replaceOrderId: orderId);
    _registerDate = DateFormat('yyyy-MM-dd').parse(_registerDateStr);
    _deadline = null;
    _swingBox.put('oi', _orderIdNew);
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop(RouteManager.orderPage);
    }
    notifyListeners();
  }
}
