import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/screens/customers/add_customer_panel.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

final Box _swingBox = Hive.box('SwingDb');

class CustomerProvider extends ChangeNotifier {
  //constructor initialize all orders
  CustomerProvider() {
    _orderRegister = formatMyDate(myDate: DateTime.now()) as DateTime;
  }

  static const fieldKeyForName = 'name';
  static const fieldKeyForLast = 'last';
  static const fieldKeyForPhone = 'phone';
  static int _orderIdNew = (_swingBox.get('oi') as int?) ?? 0;
  Color _deadlineOrderColor = AppColorsAndThemes.secondaryColor;
  late final Customer _targetCustomer;
  int _orderRemainingPrice = 0;
  Map<String, String> _orderTimeMap = {};

  late DateTime _orderRegister; //=> this is valued in constructor
  DateTime? _orderDeadline;

  DateTime? _registerDate;
  final Map<String, bool> _errors = {};

  List<Customer> _customerList =
      _swingBox.values.whereType<Customer>().toList().cast<Customer>();
  List<Order> _customerOrders = [];
  String _selectedFilter =
      (_swingBox.get('filterValueKey') as String?) ?? 'In Progress';

  bool _customerStatus = false;
  final List<String> filterOptions = [
    'In Progress',
    'Swen NOT Delivered',
    'Sewn & Delivered',
    'All'
  ];
  final List<String> selectableOrderStatus = [
    'In Progress',
    'Swen NOT Delivered',
    'Sewn & Delivered',
  ];

  void initializeCustomerOrders({required String customerId}) {
    final Customer targetCustomer = customer(customerId);
    _customerOrders = targetCustomer.customerOrder;
    notifyListeners();
  }

  // Getters ====================================================================
  List<Customer> get getCustomers => _customerList;

  Color get getDeadlineOrderColor => _deadlineOrderColor;

  DateTime? get getOrderRegister => _orderRegister;

  DateTime? get getOrderDeadline => _orderDeadline;

  List<Order> get getOrders => _customerOrders;

  Map<String, String> get getOrderTimeMap => _orderTimeMap;

  int get getOrderRemainingPrice => _orderRemainingPrice;

  bool getError(String field) => _errors[field] ?? false;

  String? get getSelectedFilter => _selectedFilter;

  DateTime? get showRegisterDate => _registerDate;

  bool get customerStatus => _customerStatus;

  // METHODS ========================================================================

  // getting target customer out of list
  Customer customer(String customerId) {
    _targetCustomer = _customerList.firstWhere((foundCustomer) => foundCustomer.id == customerId);
    return _targetCustomer;
  }

  /// TO change deadline color when it is selected or not [blue] while selected [red] while not selected
  void changeDeadlineColor({required bool changeToRed}) {
    if (changeToRed) {
      _deadlineOrderColor = Colors.red.shade900;
      notifyListeners();
    } else {
      _deadlineOrderColor = AppColorsAndThemes.secondaryColor;
      notifyListeners();
    }
  }

/// This method is used while tapping on an order to edit [Sets the register date as well as deadline]
  void setOrderDeadline({required String orderId, required String customerId}) {
    // if (orderId.isNotEmpty) {
      print('p1- SET ORDER METHOD IN CProvider: $orderId');
      final order = Order.fromId(orderId: orderId, customerId: customerId);
      print('p3- Order: $order');
      _orderRegister = order.registeredDate;
      _orderDeadline = order.deadLineDate;
      changeDeadlineColor(changeToRed: false);
    // } else {
      print('p2- SET ORDER METHOD IN CProvider: $orderId');
      // _orderTimeMap['register'] =
      //     formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
      // _orderTimeMap['deadline'] = 'Pick a deadline;-)';
    // }
    notifyListeners();
  }
  /// Pick register date while saving or editing an order
  Future<void> pickRegisterDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: formatMyDate(myDate: DateTime.now()) as DateTime,
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _orderRegister =
      formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimeMap['register'] =
      formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
      notifyListeners();
    }
  }

  /// pick deadline date while saving or editing an order
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: formatMyDate(myDate: DateTime.now()) as DateTime,
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _orderDeadline =
      formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimeMap['deadline'] =
      formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
      changeDeadlineColor(changeToRed: false);
      notifyListeners();
    }
  }

  // setting remaining money
  int setRemainingPrice(double total, double received) {
    _orderRemainingPrice = total.toInt() - received.toInt();
    notifyListeners();
    return _orderRemainingPrice;
  }


  void setOrderTimes({required String orderId, required String customerId}) {
    if (orderId.isEmpty) {
      return;
    }
    final Order order = Order.fromId(orderId: orderId, customerId: customerId);
    _orderRegister = order.registeredDate;
    _orderDeadline = order.deadLineDate;
    _orderTimeMap['register'] =
        formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
    _orderTimeMap['deadline'] = formatMyDate(
            myDate: _orderDeadline!, returnAsDate: false)
        as String; // if this runs error try order.deadline instead of _orderDeadline!
  }

  // This method is to get a date and return a formatted date just to make the future codes more cleaner LIKE 2024-01-21 - 00:00:00
  dynamic formatMyDate({required DateTime? myDate, bool returnAsDate = true}) {
    if (myDate == null) {
      _orderTimeMap['deadline'] = 'Pick a deadline';
      notifyListeners();
      return;
    }
    final String dateStr = DateFormat('yyyy-MM-dd').format(myDate!);
    DateTime myTime = DateFormat('yyyy-MM-dd').parse(dateStr);
    return returnAsDate
        ? myTime
        : '${myTime.day}-${myTime.month}-${myTime.year}';
  }

  // handle error while saving new or edited order
  bool handleErrorWhileSaving(BuildContext context) {
    if (_orderDeadline == null) {
      changeDeadlineColor(changeToRed: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Pick a deadline date'),
        ),
      );
      return true;
    }
    return false;
  }

  // ADD NEW ORDER TO THE TARGET CUSTOMER
  Future<void> saveNewOrder(
      {required BuildContext context,required Order targetOrder, required String customerId}) async {
print('p1- inside saveNewOrder M- in Cp ${targetOrder.id} =================');
    final Order newOrder = Order(
      customerId: customerId,
      id: _orderIdNew.toString(),
      isDone: targetOrder.isDone,
      isDelivered: targetOrder.isDelivered,
      registeredDate: targetOrder.registeredDate,
      deadLineDate: targetOrder.deadLineDate,
      qad: targetOrder.qad,
      shana: targetOrder.shana,
      astinSada: targetOrder.astinSada,
      astinKaf: targetOrder.astinKaf,
      yeqa: targetOrder.yeqa,
      beghal: targetOrder.beghal,
      shalwar: targetOrder.shalwar,
      parcha: targetOrder.parcha,
      qout: targetOrder.qout,
      damAstin: targetOrder.damAstin,
      barAstin: targetOrder.barAstin,
      jibShalwar: targetOrder.jibShalwar,
      qadPuti: targetOrder.qadPuti,
      barShalwar: targetOrder.barShalwar,
      faq: targetOrder.faq,
      doorezano: targetOrder.doorezano,
      kaf: targetOrder.kaf,
      jibRoo: targetOrder.jibRoo,
      damanRast: targetOrder.damanRast,
      damanGerd: targetOrder.damanGerd,
      model: targetOrder.model,
      totalCost: targetOrder.totalCost,
      receivedMoney: targetOrder.receivedMoney,
      remainingMoney: targetOrder.receivedMoney,
    );
print('p2- inside saveNewOrder M- in Cp ${newOrder.id} =================');
    await Customer.addNewOrder(
        newOrder: newOrder,
        customerId: customerId,
        replaceOrderId: targetOrder.id);
    await _swingBox.put('oi', _orderIdNew);
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop(RouteManager.orderPage);
    }
    _orderTimeMap = {};
    _orderRegister = DateTime.now();
    _orderDeadline = null;
    notifyListeners();
  }

  // format date to show as String
  String betterFormatedDate(DateTime dateTime) {
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }

  void changeCustomerStatus(bool status) {
    _customerStatus = status;
    notifyListeners();
  }

  // SELECT NEW DATE WHEN ADDING NEW CUSTOMER
  void selectRegisterDate({required BuildContext context}) async {
    final getDate = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2200));
    if (getDate != null) {
      _registerDate = getDate;
    }
    notifyListeners();
  }

  //TO VALIDATE text field
  void validate(String field, String value) {
    _errors[field] = value.isEmpty;
    notifyListeners();
  }

  // on Cancel ADDING CUSTOMERS
  void onCancel(BuildContext context) {
    validate(
        fieldKeyForName, 'some thing not to show error on cancel and return');
    validate(
        fieldKeyForLast, 'some thing not to show error on cancel and return');
    validate(
        fieldKeyForPhone, 'some thing not to show error on cancel and return');
    Navigator.of(context).pop(RouteManager.customerProfile);
  }

  // CURRENTLY JUST USED INSIDE [onSave] Method
  bool _ifInputsEmpty(
      BuildContext context, String name, String lastName, String phoneOne) {
    if (name.isEmpty || lastName.isEmpty || phoneOne.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('inputs cannot be empty'),
        ),
      );
      return true;
    }
    return false;
  }

// CURRENTLY JUST USED INSIDE THE [onSave] method
  bool _ifInputLengthInvalid(
    BuildContext context,
    String number,
  ) {
    if (number.isNotEmpty) {
      if (number.length < 8) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number is not valid'),
          ),
        );
        return true;
      }
    }
    return false;
  }

// ON SAVING NEW CUSTOMER to Hive through show model button sheet when pressing on [+ New Customer]
  Future<void> onSave({
    required String name,
    required String lastName,
    required String phoneOne,
    required String phoneTwo,
    required BuildContext context,
    Customer? customer,
  }) async {
    validate(fieldKeyForName, name);
    validate(fieldKeyForLast, lastName);
    validate(fieldKeyForPhone, phoneOne);

    bool ifInputEmpty = _ifInputsEmpty(context, name, lastName, phoneOne);
    bool ifLengthInvalid = _ifInputLengthInvalid(context, phoneOne);
    bool ifLengthInvalidTwo = _ifInputLengthInvalid(context, phoneTwo);
    if (ifInputEmpty || ifLengthInvalid || ifLengthInvalidTwo) {
      return;
    }
    String newCustomerId = '$name${phoneOne.substring(4)}';
    final String todayStr = DateFormat('yyyy-MM-ddd').format(DateTime.now());
    final DateTime today = DateFormat('yyyy-MM-ddd').parse(todayStr);
    Customer newCustomer = Customer(
        id: customer != null ? customer.id : newCustomerId,
        registerDate:
            customer != null ? customer.registerDate : _registerDate ?? today,
        firstName: name,
        lastName: lastName,
        phoneNumber1: '07$phoneOne',
        phoneNumber2: '07$phoneTwo',
        customerOrder: customer != null ? customer.customerOrder : [],
        status: customerStatus);
    await _swingBox.put(newCustomer.id, newCustomer);
    _customerList =
        _swingBox.values.whereType<Customer>().cast<Customer>().toList();
    notifyListeners();
    for (Customer cc in _customerList) {
      print('Name: ${cc.firstName} \t ${cc.status}');
    }
    if (context.mounted) {
      Navigator.of(context).pop(RouteManager.customerProfile);
    }
  }

  // ADD NEW CUSTOMER
  void onAddNewCustomerBtn(BuildContext context, {Customer? customer}) {
    showModalBottomSheet(
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => FractionallySizedBox(
        heightFactor: .9,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
          child: CustomShowModelSheet(
            customer: customer,
          ),
        ),
      ),
    );
    notifyListeners();
  }

// DELETE AN EXISTING CUSTOMER
  Future<void> deleteCustomer(
      {required BuildContext context, required Customer customer}) async {
    await _swingBox.delete(customer.id);
    _customerList.removeWhere((element) => element == customer);
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile successfully Deleted')));
    }
  }

  // change color of the orders base on expiration date
  Color deadlineColor(Order order, Color normal, Color past, Color justToday) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final today = DateFormat('yyyy-MM-dd').parse(todayStr);
    return order.deadLineDate.isAtSameMomentAs(today)
        ? justToday
        : order.deadLineDate.isBefore(today)
            ? past
            : normal;
    notifyListeners();
  }

  // font size for deadline texts
  double deadlineFont(Order order) {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final today = DateFormat('yyyy-MM-dd').parse(todayStr);
    return order.deadLineDate.isAtSameMomentAs(today)
        ? 17.5
        : order.deadLineDate.isBefore(today)
            ? 17.5
            : 16;
    notifyListeners();
  }

  // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  void filterValues(
      {required String? value, required String customerId}) async {
    switch (value) {
      case 'All':
        _customerOrders = customer(customerId).customerOrder;
        notifyListeners();
        break;
      case 'Swen NOT Delivered':
        _customerOrders = customer(customerId)
            .customerOrder
            .where((foundOrder) =>
                foundOrder.isDone == true && foundOrder.isDelivered == false)
            .toList();
        print('########S N D######## ${_customerOrders}');
        notifyListeners();
        break;
      case 'Sewn & Delivered':
        _customerOrders = customer(customerId)
            .customerOrder
            .where((foundOrder) =>
                foundOrder.isDelivered == true && foundOrder.isDone == true)
            .toList();
        print('######## S  D ######## ${_customerOrders}');
        notifyListeners();
        break;
      case 'In Progress':
        _customerOrders = customer(customerId)
            .customerOrder
            .where((foundOrder) =>
                foundOrder.isDone == false && foundOrder.isDelivered == false)
            .toList();
        print('######## In Progress ######## ${_customerOrders}');
        notifyListeners();
        break;
    }
  }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  void onChangeFilterValue(
      {required String? newValue, required String customerId}) async {
    if (newValue != null) {
      _selectedFilter = newValue;
      filterValues(value: newValue, customerId: customerId);
      await _swingBox.put('filterValueKey', newValue);
      notifyListeners();
    }
  }

  // This METHOD MATCHED THE COLOR OF POPUPMENU CIRCLES WITH THE LEADING
  // CIRCLE OF EACH CARD
  Color circleMatchWithPopupValueColor({required Order order}) {
    return (order.isDone && order.isDelivered)
        ? Colors.green.shade800
        : (order.isDone && !order.isDelivered)
            ? AppColorsAndThemes.secondaryColor
            : Colors.orange.shade700;
    notifyListeners();
  }

// ON ORDER POPUP
  void onPopupMenu(
      {required Order order,
      required String value,
      required Customer customer}) async {
    const String sewnNotDelivered = 'Sewn NOT delivered';
    const String sewnAndDelivered = 'Sewn & delivered';
    const String inProgress = 'In progress';
    switch (value) {
      case sewnNotDelivered:
        order.isDone = true;
        order.isDelivered = false;
        notifyListeners();
        break;
      case sewnAndDelivered:
        order.isDone = true;
        order.isDelivered = true;
        notifyListeners();
        break;
      case inProgress:
        order.isDone = false;
        order.isDelivered = false;
        notifyListeners();
        break;
    }
    await Customer.addNewOrder(
        newOrder: order, customerId: customer.id, replaceOrderId: order.id);
    notifyListeners();
  }
}
