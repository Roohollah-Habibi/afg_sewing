import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/screens/customers/add_customer_panel.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
enum PriceType { total, received, remaining }
Map<String,int> _orderStatusColorFromDb = (Constants.swingBox.get('orderStatusColor') as Map?)?.cast<String,int>() ?? {};
class CustomerProvider extends ChangeNotifier {
  CustomerProvider() {
    _orderRegister = Constants.formatMyDate(myDate: DateTime.now()) as DateTime;
  }  //constructor initialize all orders ==================================================
  double _orderTotalPrice = 0;
  double _orderReceivedPrice = 0;
  int _orderRemainingPrice = 0;
  final List<String> _profileFilterList = [
    'All',
    'In Progress',
    'Sewn & Delivered',
    'Sewn NOT Delivered',
    'Expired',
    'Just today'];// this variable shows filters in profile and report pages
  String _selectedFilter = (Constants.swingBox.get('profileFilterValue') as String?) ?? 'All';
  String _reportSelectedFilterValue = (Constants.swingBox.get('reportFilterValue') as String?) ?? 'All';
  // this stores the status color for each order in order to use them inside all order page
  Map<String, Color> _reportOrderStatusColor = _orderStatusColorFromDb.map((key, value) => MapEntry(key, Color(value)));
  Color _deadlineOrderColor = AppColorsAndThemes.secondaryColor;// this is default color but changes when user not select a deadline
  /// This map is used to save register and deadline date info. as String
  Map<String, String> _orderTimesInfo = {};

  late DateTime _orderRegister; //=> this is valued in constructor
  DateTime? _orderDeadline;
  late DateTime _customerRegisterDate;
  final Map<String, bool> _errors = {};

  List<Customer> _customerList = Constants.swingBox.values.whereType<Customer>().toList().cast<Customer>();
  List<Order> _reportOrders = Constants.swingBox.values.whereType<Customer>().toList().cast<Customer>().expand((element) => element.customerOrder).toList();
  List<Order> _allCustomersOrders = [];

  List<bool> _expandedStatusForReports = [];

  // bool _isCollapsed = true
  bool _customerStatus = false;

  // Getters ====================================================================
  List<Customer> get getCustomers => _customerList;

  Map<String,Color> get getReportOrderStatusColor => _reportOrderStatusColor;
  List<bool> get getExpandedStatusListForReports => _expandedStatusForReports;
  bool isCollapsed(int index) => getExpandedStatusListForReports[index];
  String get getSelectedReport => _reportSelectedFilterValue;
  List<Order> get reportOrders => _reportOrders;
  List<Order> get getReportOrders => _reportOrders;
  List<String> get getProfileFilters => _profileFilterList;
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

  DateTime get getCustomerRegisterDate => _customerRegisterDate;

  bool get customerStatus => _customerStatus;

  // METHODS ========================================================================
  void toggleExpansion({bool isExpanded = true, int? index}){
    if(index != null){
      _expandedStatusForReports.removeAt(index);
      _expandedStatusForReports.insert(index, !isExpanded);
    notifyListeners();
    }else{
      setExpanded();
    notifyListeners();
    }
  }
  /// to change the status of each expanded list by calling change notifier
  void setExpanded() {
    _expandedStatusForReports = List.generate(_reportOrders.length, (index) => true);
  }

  /// getting target customer out of list
  Customer customer(String customerId) => _customerList.firstWhere((foundCustomer) => foundCustomer.id == customerId);

  /// this method is used to delete an order from both order list and the database.
  void removeOrderFromOrderList({required Order removableOrder, required String customerId}) {
    _allCustomersOrders.removeWhere(
      (element) => element.id == removableOrder.id,
    );
    _reportOrders.removeWhere((element) => element.id == removableOrder.id);
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
      Constants.formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
      _orderTimesInfo['deadline'] =
      Constants.formatMyDate(myDate: _orderDeadline!, returnAsDate: false) as String;
      // changeDeadlineColor(changeToRed: false);
    } else {
      _orderRegister = Constants.formatMyDate(myDate: DateTime.now(), returnAsDate: true) as DateTime;
      _orderTimesInfo['register'] =
      Constants.formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
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
    Constants.formatMyDate(myDate: _orderRegister, returnAsDate: false) as String;
    _orderTimesInfo['deadline'] =
    Constants.formatMyDate(myDate: _orderDeadline!, returnAsDate: false) as String;
  }

  /// Pick register date while saving or editing an order
  Future<void> pickRegisterDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: Constants.formatMyDate(myDate: DateTime.now()) as DateTime,
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _orderRegister = Constants.formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimesInfo['register'] = Constants.formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
      notifyListeners();
    }
  }

  /// pick deadline date while saving or editing an order
  Future<void> pickDeadline(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: Constants.formatMyDate(myDate: DateTime.now()) as DateTime,
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );
    if (pickedDate != null) {
      _orderDeadline = Constants.formatMyDate(myDate: pickedDate, returnAsDate: true) as DateTime;
      _orderTimesInfo['deadline'] = Constants.formatMyDate(myDate: pickedDate, returnAsDate: false) as String;
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
    final Customer saveCustomerWithStatus = customer(customerId);
    saveCustomerWithStatus.status = true;
    await Constants.swingBox.put(customerId, saveCustomerWithStatus);
    _orderTotalPrice = 0;
    _orderReceivedPrice = 0;
    _orderRemainingPrice = 0;
    if(targetOrder.id.isEmpty){
      _reportOrderStatusColor[newOrder.id] = Colors.orange;
    }
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

  /// DELETE AN EXISTING CUSTOMER and show an snack bar to notify user for successful deletion
  Future<void> deleteCustomer({required BuildContext context, required Customer customer}) async {
    await Constants.swingBox.delete(customer.id);
    _customerList.removeWhere((element) => element == customer);
    _reportOrders.removeWhere((element) => element.customerId == customer.id);
    notifyListeners();
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile successfully Deleted'),duration: const Duration(milliseconds: 400),));
    }
  }

  void changeCustomerStatus(bool status) {
    _customerStatus = status;
  }

  // SELECT NEW DATE WHEN ADDING NEW CUSTOMER
  void selectRegisterDate({required BuildContext context}) async {
    final getDate = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2200));
    if (getDate != null) {
      _customerRegisterDate = Constants.formatMyDate(myDate: getDate) as DateTime;
    notifyListeners();
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
    validate(Constants.fieldKeyForName, 'some thing not to show error on cancel and return');
    validate(Constants.fieldKeyForLast, 'some thing not to show error on cancel and return');
    validate(Constants.fieldKeyForPhone, 'some thing not to show error on cancel and return');
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

/// ON SAVING NEW CUSTOMER to Hive through show model button sheet when pressing on [+ New Customer]
  Future<void> onSaveCustomer({
    required String name,
    required String lastName,
    required String phoneOne,
    required String phoneTwo,
    required BuildContext context,
    Customer? customer,
  }) async {

    validate(Constants.fieldKeyForName, name);
    validate(Constants.fieldKeyForLast, lastName);
    validate(Constants.fieldKeyForPhone, phoneOne);
    bool ifInputEmpty = _ifInputsEmpty(context, name, lastName, phoneOne);
    bool ifLengthInvalid = _ifInputLengthInvalid(context, phoneOne);
    bool ifLengthInvalidTwo = _ifInputLengthInvalid(context, phoneTwo);
    if (ifInputEmpty || ifLengthInvalid || ifLengthInvalidTwo) {
      return;
    }
    String newCustomerId = '$name${phoneOne.substring(4)}';
    late Customer newCustomer;
    if(customer != null){
      newCustomer = Customer(
          id: customer.id,
          registerDate: _customerRegisterDate,
          firstName: name,
          lastName: lastName,
          phoneNumber1: '07$phoneOne',
          phoneNumber2: '07$phoneTwo',
          customerOrder: customer.customerOrder ,
          status: customerStatus);
      notifyListeners();
    }else{
      newCustomer = Customer(
          id: newCustomerId,
          registerDate:_customerRegisterDate,
          firstName: name,
          lastName: lastName,
          phoneNumber1: '07$phoneOne',
          phoneNumber2: '07$phoneTwo',
          customerOrder:  [],
          status: customerStatus);
      notifyListeners();
    }
    await Constants.swingBox.put(newCustomer.id, newCustomer);
    notifyListeners();
    _customerList = Constants.swingBox.values.whereType<Customer>().toList();
    int foundCustomerIndexFromList = _customerList.indexOf(newCustomer);
    if(foundCustomerIndexFromList < 0){
      _customerList.insert(0, newCustomer);
    notifyListeners();
    }else{
      _customerList.removeAt(foundCustomerIndexFromList);
      _customerList.insert(foundCustomerIndexFromList, newCustomer);
      notifyListeners();
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    notifyListeners();
  }

  /// ADD NEW CUSTOMER
  void onAddNewCustomerBtn(BuildContext context, {Customer? customer}) {
    notifyListeners();
    _customerRegisterDate = Constants.formatMyDate(myDate: customer?.registerDate ?? DateTime.now()) as DateTime;
    print('========== $_customerRegisterDate');
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
          child: AddCustomerPanel(
            customer: customer,
          ),
        ),
      ),
    );
    notifyListeners();
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
    List<Order> allOrders = Constants.swingBox.values
        .whereType<Customer>()
        .toList()
        .cast<Customer>()
        .expand(
          (element) => element.customerOrder,
        )
        .toList();
    DateTime today = Constants.formatMyDate(myDate: DateTime.now()) as DateTime;
    switch (value) {
      case 'All':
        if (!filterValueForReport) {
          _allCustomersOrders = customer(customerId)
              .customerOrder
              .where(
                (element) => element.customerId == customerId,
              )
              .toList();
        }
        _reportOrders = allOrders;
        if(shouldNotify)notifyListeners();

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
        if(shouldNotify)notifyListeners();
        break;

      case 'In Progress':
        if (!filterValueForReport)
          _allCustomersOrders = customer(customerId).customerOrder.where((foundOrder) => foundOrder.isDone == false && foundOrder.isDelivered == false).toList();
        _reportOrders = allOrders.where((element) => element.isDone == false && element.isDelivered == false)
            .toList();
        if(shouldNotify)notifyListeners();
        break;

      case 'Expired':
        if(!filterValueForReport)_allCustomersOrders = customer(customerId).customerOrder.where((foundOrder) => foundOrder.deadLineDate.isBefore
          (today)).toList();

        _reportOrders = allOrders.where((element) => element.deadLineDate.isBefore(today)).toList();

        if(shouldNotify)notifyListeners();
        break;
      case 'Just today':
        _reportOrders =
            allOrders.where((element) => element.deadLineDate.isAtSameMomentAs(today)).toList();
        if(shouldNotify)notifyListeners();
        break;
    }
    if(shouldNotify)notifyListeners();
  }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  void onChangeFilterValue({required String newValue, required String customerId}) async {
    _selectedFilter = newValue;
    await Constants.swingBox.put('profileFilterValue', _selectedFilter);
    filterValues(value: _selectedFilter, customerId: customerId);
  }

  void onChangeReportFilterValue(String newValue) async{
    _reportSelectedFilterValue = newValue;
    await Constants.swingBox.put('reportFilterValue', _reportSelectedFilterValue);
    filterValues(value: newValue, filterValueForReport: true);
  }

  /// This METHOD MATCHED THE COLOR OF POPUPMENU CIRCLES WITH THE LEADING CIRCLE OF EACH CARD
  Color circleMatchWithPopupValueColor({required Order order}) {
    late Color circleColor;
    if (order.isDone && order.isDelivered) {
      circleColor = Colors.green.shade800;
    }
    if (order.isDone && !order.isDelivered) {
      circleColor = AppColorsAndThemes.accentColor;
    }
    if (!order.isDone && !order.isDelivered) {
      circleColor = Colors.orange.shade700;
    }
    return circleColor;
  }

// ON ORDER POPUP
  void onPopupMenu(
      {required Order order, required String value, required Customer customer}) async {
    Map<String,int> localStatusOrderColor = {};
    switch (value) {
      case 'Sewn NOT Delivered':
        order.isDone = true;
        order.isDelivered = false;
        _reportOrderStatusColor[order.id] = AppColorsAndThemes.accentColor;
            notifyListeners();
        break;
      case 'Sewn & Delivered':
        order.isDone = true;
        order.isDelivered = true;
        _reportOrderStatusColor[order.id] = Colors.green.shade800;
        notifyListeners();
        break;
      case 'In Progress':
        order.isDone = false;
        order.isDelivered = false;
        _reportOrderStatusColor[order.id] = Colors.orange.shade700;
        notifyListeners();
        break;
    }
    filterValues(value: _selectedFilter,customerId: customer.id);
    await Customer.addNewOrder(newOrder: order, customerId: customer.id, replaceOrderId: order.id);
    localStatusOrderColor = _reportOrderStatusColor.map((key, value) => MapEntry(key, value.value));
    await Constants.swingBox.put('orderStatusColor', localStatusOrderColor);
    notifyListeners();
  }
  Map<String,dynamic> reportInfoBaseDate({int day = 1}){
    List<Order> allOrder = _customerList.expand((element) => element.customerOrder).toList();
    List<Customer> customer = _customerList.where((foundCustomer) => Constants.todayAsDate.difference(foundCustomer.registerDate).inDays <= day).toList();
    List<Order> orders = allOrder.where((foundOrder) => Constants.todayAsDate.difference(foundOrder.registeredDate).inDays <= day).toList();
    return {
      'customers': customer.length,
      'orders':orders.length};
  }

  String translateFilter(BuildContext context, String filter) {
    switch (filter) {
      case 'All':
        return AppLocalizations.of(context)!.all;
      case 'In Progress':
        return AppLocalizations.of(context)!.inProgress;
      case 'Sewn & Delivered':
        return AppLocalizations.of(context)!.sewnAndDelivered;
      case 'Sewn NOT Delivered':
        return AppLocalizations.of(context)!.sewnNotDelivered;
      case 'Expired':
        return AppLocalizations.of(context)!.expired;
      case 'Just today':
        return AppLocalizations.of(context)!.justToday;
      default:
        return filter;
    }
  }

}
