import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/screens/customers/add_customer_panel.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final Box _swingBox = Hive.box('SwingDb');

enum PriceType { total, received, remaining }

class CustomerProvider extends ChangeNotifier {
  //constructor initialize all orders
  CustomerProvider() {
    _orderRegister = formatMyDate(myDate: DateTime.now()) as DateTime;
  }

  final profileFilterList = [
    'All',
    'In Progress',
    'Sewn & Delivered',
    'Sewn NOT Delivered',
    'Expired',
  ];
  static const fieldKeyForName = 'name';
  static const fieldKeyForLast = 'last';
  static const fieldKeyForPhone = 'phone';
  Color _deadlineOrderColor = AppColorsAndThemes.secondaryColor;
  double _orderTotalPrice = 0;
  double _orderReceivedPrice = 0;
  int _orderRemainingPrice = 0;

  /// This map is used to save register and deadline date info. as String
  Map<String, String> _orderTimesInfo = {};

  late DateTime _orderRegister; //=> this is valued in constructor
  DateTime? _orderDeadline;

  DateTime? _registerDate;
  final Map<String, bool> _errors = {};

  List<Customer> _customerList = _swingBox.values.whereType<Customer>().toList().cast<Customer>();

  List<Order> _allCustomersOrders = [];

  late List<Order> _reportOrders = _swingBox.values
      .whereType<Customer>()
      .toList()
      .cast<Customer>()
      .expand(
        (element) => element.customerOrder,
      )
      .toList();

  String _selectedFilter = (_swingBox.get('profileFilterValue') as String?) ?? 'All';
  String _reportSelectedFilterValue = 'All';

  bool _customerStatus = false;
  final List<String> selectableOrderStatus = [
    'In Progress',
    'Swen NOT Delivered',
    'Sewn & Delivered',
  ];

  // Getters ====================================================================
  List<Customer> get getCustomers => _customerList;

  String get getSelectedReport => _reportSelectedFilterValue;

  List<Order> get getReportOrders => _reportOrders;

  Color get getDeadlineOrderColor => _deadlineOrderColor;

  DateTime? get getOrderRegister => _orderRegister;

  DateTime? get getOrderDeadline => _orderDeadline;

  List<Order> get getOrders => _allCustomersOrders;

  Map<String, String> get getOrderInfo => _orderTimesInfo;

  double get getTotalPrice => _orderTotalPrice;

  double get getReceivedPrice => _orderReceivedPrice;

  int get getOrderRemainingPrice => _orderRemainingPrice;

  bool getError(String field) => _errors[field] ?? false;

  String get getSelectedFilter => _selectedFilter;

  DateTime? get showRegisterDate => _registerDate;

  bool get customerStatus => _customerStatus;

  // METHODS ========================================================================


  /// getting target customer out of list
  Customer customer(String customerId) =>
      _customerList.firstWhere((foundCustomer) => foundCustomer.id == customerId);

  /// this method is used to delete an order from both order list and the database.
  void removeOrderFromOrderList({required Order removableOrder, required String customerId}) {
    _allCustomersOrders.removeWhere(
      (element) => element.id == removableOrder.id,
    );
    Customer.removeOrder(customerId: customerId, removableOrder: removableOrder);
    notifyListeners();
  }

  /// this method is used to add an order to the order list only not to the database. to add an
  /// order to the db use Customer class.
  void addOrderToOrderList({required Order targetOrder}) {
    _allCustomersOrders.add(targetOrder);
    notifyListeners();
  }

  /// this method return list of orders of customer by getting customerId
  List<Order> findOrderListByCustomerId(String customerId) => _allCustomersOrders
      .where(
        (element) => element.customerId == customerId,
      )
      .toList();

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

  /// This method is used while tapping on an order to edit [Sets the register date as well as deadline] and when to add new order sets everything to default [register: today date and deadline: pick a deadline and ]
  void checkAndSetOrderDeadline({required String orderId, required String customerId}) {
    if (orderId.isNotEmpty) {
      final order = Order.fromId(orderId: orderId, customerId: customerId);
      _orderRegister = order.registeredDate;
      _orderDeadline = order.deadLineDate;
      _orderTimesInfo['register'] =
          formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
      _orderTimesInfo['deadline'] =
          formatMyDate(myDate: _orderDeadline!, returnAsDate: false) as String;
      // changeDeadlineColor(changeToRed: false);
    } else {
      _orderRegister = formatMyDate(myDate: DateTime.now(), returnAsDate: true) as DateTime;
      _orderTimesInfo['register'] =
          formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
      _orderTimesInfo['deadline'] = 'Pick a deadline';
    }
  }

  // this method is to set register and deadline info into the map[OrderTimesInfo] works the same [checkAndSetOrderDeadline] method.
  @deprecated
  void setOrdersDeadlineInfo({required String orderId, required String customerId}) {
    if (orderId.isEmpty) {
      return;
    }
    final Order order = Order.fromId(orderId: orderId, customerId: customerId);
    _orderRegister = order.registeredDate;
    _orderDeadline = order.deadLineDate;
    _orderTimesInfo['register'] =
        formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
    _orderTimesInfo['deadline'] =
        formatMyDate(myDate: _orderDeadline!, returnAsDate: false) as String;
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
      _orderRegister = formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimesInfo['register'] = formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
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
      _orderDeadline = formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimesInfo['deadline'] = formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
      changeDeadlineColor(changeToRed: false);
      notifyListeners();
    }
  }

  void setPriceValue({required PriceType price, String value = ''}) {
    switch (price) {
      case PriceType.total:
        _orderTotalPrice = double.tryParse(value) ?? 0;
      case PriceType.received:
        _orderReceivedPrice = double.tryParse(value) ?? 0;
      case PriceType.remaining: // this line of code is used inside [initState]of Order_page
        _orderRemainingPrice = (_orderTotalPrice.toInt() - _orderReceivedPrice.toInt());
    }
    // this line of code ensures the remaining price is always set either one of Prices or both set. COOL ;->
    _orderRemainingPrice = (_orderTotalPrice.toInt() - _orderReceivedPrice.toInt());
    // notify listener should not be used bease this method is used inside onChange method of textfields and initState of order_page
  }

  double setRemainingPrice({required double total, required double received}) {
    _orderRemainingPrice = (_orderTotalPrice.toInt() - _orderReceivedPrice.toInt());
    return _orderReceivedPrice;
  }

  // This method is to get a date and return a formatted date just to make the future codes more cleaner LIKE 2024-01-21 - 00:00:00
  dynamic formatMyDate({required DateTime? myDate, bool returnAsDate = true}) {
    final String dateStr = DateFormat('yyyy-MM-dd').format(myDate!);
    DateTime myTime = DateFormat('yyyy-MM-dd').parse(dateStr);
    return returnAsDate ? myTime : '${myTime.day}-${myTime.month}-${myTime.year}';
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

  /// THIS method is used to cancel an order
  void onCancelOrder({required BuildContext context, required String orderId}) {
    _orderDeadline = null;
    changeDeadlineColor(changeToRed: false);
    getOrderInfo['deadline'] = 'Pick a deadline';
    _orderTotalPrice = 0;
    _orderReceivedPrice = 0;
    _orderRemainingPrice = 0;
    Navigator.of(context).pop();
    notifyListeners();
  }

  // ADD NEW ORDER TO THE TARGET CUSTOMER
  Future<void> saveNewOrder(
      {required BuildContext context,
      required Order targetOrder,
      required String customerId}) async {
    const uuid = Uuid();
    final Order newOrder = Order(
      customerId: customerId,
      id: targetOrder.id.isEmpty ? uuid.v4() : targetOrder.id,
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
      remainingMoney: _orderRemainingPrice,
    );
    await Customer.addNewOrder(newOrder: newOrder, customerId: customerId, replaceOrderId: targetOrder.id);

    _orderTotalPrice = 0;
    _orderReceivedPrice = 0;
    _orderRemainingPrice = 0;
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop(RouteManager.orderPage);
      filterValues(value: _selectedFilter,customerId: customerId);
    }
    _orderTimesInfo = {};
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
    final getDate =
        await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2200));
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
    validate(fieldKeyForName, 'some thing not to show error on cancel and return');
    validate(fieldKeyForLast, 'some thing not to show error on cancel and return');
    validate(fieldKeyForPhone, 'some thing not to show error on cancel and return');
    Navigator.of(context).pop(RouteManager.customerProfile);
  }

  // CURRENTLY JUST USED INSIDE [onSave] Method
  bool _ifInputsEmpty(BuildContext context, String name, String lastName, String phoneOne) {
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
        registerDate: customer != null ? customer.registerDate : _registerDate ?? today,
        firstName: name,
        lastName: lastName,
        phoneNumber1: '07$phoneOne',
        phoneNumber2: '07$phoneTwo',
        customerOrder: customer != null ? customer.customerOrder : [],
        status: customerStatus);
    await _swingBox.put(newCustomer.id, newCustomer);
    _customerList = _swingBox.values.whereType<Customer>().cast<Customer>().toList();
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
  Future<void> deleteCustomer({required BuildContext context, required Customer customer}) async {
    await _swingBox.delete(customer.id);
    _customerList.removeWhere((element) => element == customer);
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile successfully Deleted')));
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
  }

  /// SHOW FILTER VALUES FOR DROPDOWN BUTTON this should be called first in init state in profile
  /// when navigating back and come back to the profile show the appropriate list according to the filter options and
  /// also when saving new to automatically filter values and shows order. otherwise user must change the filter in
  /// order to see the changes.
  void filterValues(
      {required String value, String customerId = '', bool filterValueForReport = false,bool
      shouldNotify = true}) async {
    List<Order> allOrders = _swingBox.values
        .whereType<Customer>()
        .toList()
        .cast<Customer>()
        .expand(
          (element) => element.customerOrder,
        )
        .toList();
    DateTime today = formatMyDate(myDate: DateTime.now()) as DateTime;
    switch (value) {
      case 'All':
        if (!filterValueForReport)
          _allCustomersOrders = customer(customerId)
              .customerOrder
              .where(
                (element) => element.customerId == customerId,
              )
              .toList();
        _reportOrders = allOrders;
        if(shouldNotify)notifyListeners();
        print('filter option all $_allCustomersOrders');
        break;
      case 'Sewn NOT Delivered':
        if (!filterValueForReport)
          _allCustomersOrders = customer(customerId)
              .customerOrder
              .where((foundOrder) => foundOrder.isDone == true && foundOrder.isDelivered == false)
              .toList();
        _reportOrders = allOrders
            .where((element) => element.isDone == true && element.isDelivered == false)
            .toList();
        print('filter option SND $_allCustomersOrders');
        if(shouldNotify)notifyListeners();
        break;

      case 'Sewn & Delivered':
        if (!filterValueForReport)
          _allCustomersOrders = customer(customerId)
              .customerOrder
              .where((foundOrder) => foundOrder.isDelivered == true && foundOrder.isDone == true)
              .toList();
        _reportOrders = allOrders
            .where((element) => element.isDelivered == true && element.isDone == true)
            .toList();
        print('filter option SAD $_allCustomersOrders');
        if(shouldNotify)notifyListeners();
        break;

      case 'In Progress':
        if (!filterValueForReport)
          _allCustomersOrders = customer(customerId)
              .customerOrder
              .where((foundOrder) => foundOrder.isDone == false && foundOrder.isDelivered == false)
              .toList();
        _reportOrders = allOrders
            .where((element) => element.isDone == false && element.isDelivered == false)
            .toList();
        print('filter option in progress $_allCustomersOrders');
        if(shouldNotify)notifyListeners();
        break;
      case 'Expired':
        _reportOrders = allOrders.where((element) => element.deadLineDate.isBefore(today)).toList();
        if(shouldNotify)notifyListeners();
        break;
      case 'Just today':
        _reportOrders =
            allOrders.where((element) => element.deadLineDate.isAtSameMomentAs(today)).toList();
        if(shouldNotify)notifyListeners();
        break;
      case '2 days left':
        _reportOrders = allOrders
            .where((element) =>
                today.isAtSameMomentAs(element.deadLineDate.subtract(const Duration(days: 2))))
            .toList();
        if(shouldNotify)notifyListeners();
        break;
    }
    if(shouldNotify)notifyListeners();
  }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  void onChangeFilterValue({required String newValue, required String customerId}) async {
    _selectedFilter = newValue;
    await _swingBox.put('profileFilterValue', _selectedFilter);
    filterValues(value: _selectedFilter, customerId: customerId);
  }

  void onChangeReportFilterValue(String newValue) {
    _reportSelectedFilterValue = newValue;
    filterValues(value: newValue, filterValueForReport: true);
    notifyListeners();
  }

  /// This METHOD MATCHED THE COLOR OF POPUPMENU CIRCLES WITH THE LEADING CIRCLE OF EACH CARD
  Color circleMatchWithPopupValueColor({required Order order}) {
    late Color circleColor;
    if (order.isDone && order.isDelivered) {
      circleColor = Colors.green.shade800;
    }
    if (order.isDone && !order.isDelivered) {
      circleColor = AppColorsAndThemes.secondaryColor;
    }
    if (!order.isDone && !order.isDelivered) {
      circleColor = Colors.orange.shade700;
    }
    return circleColor;
  }

// ON ORDER POPUP
  void onPopupMenu(
      {required Order order, required String value, required Customer customer}) async {
    switch (value) {
      case 'Sewn NOT Delivered':
        order.isDone = true;
        order.isDelivered = false;

        notifyListeners();
        break;
      case 'Sewn & Delivered':
        order.isDone = true;
        order.isDelivered = true;

        notifyListeners();
        break;
      case 'In Progress':
        order.isDone = false;
        order.isDelivered = false;

        notifyListeners();
        break;
    }
    filterValues(value: _selectedFilter,customerId: customer.id);
    await Customer.addNewOrder(newOrder: order, customerId: customer.id, replaceOrderId: order.id);
    notifyListeners();
  }
}
