import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/screens/customers/add_customer_panel.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CustomerProvider extends ChangeNotifier {
  //constructor initialize all orders
  CustomerProvider() {
    _initializeAllOrders();
  }
  static const swingDbName = 'SwingDb';
  static const fieldKeyForName = 'name';
  static const fieldKeyForLast = 'last';
  static const fieldKeyForPhone = 'phone';
  String? _selectedFilter = swingBox.get('filterValueKey');
  static final Box swingBox = Hive.box(swingDbName);
  bool _customerStatus = false;
  DateTime? _registerDate;
  final Map<String, bool> _errors = {};
  List<Customer> _customerList = swingBox.values.whereType<Customer>().toList().cast<Customer>();
  List<Order> _customerOrders = [];
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


  void _initializeAllOrders(){
    _customerOrders = _customerList.expand((element) => element.customerOrder).toList();
    notifyListeners();
  }

  // Getters
  List<Customer> get getCustomers => _customerList;
  List<Order> get getOrders => _customerOrders;
  bool getError(String field) => _errors[field] ?? false;
  String? get getSelectedFilter => _selectedFilter;
  DateTime? get showRegisterDate => _registerDate;
  bool get customerStatus => _customerStatus;
  // END OF GETTERS
  // ///////////////////////////////////////////////////////////////////////////////////////

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
    await swingBox.put(newCustomer.id, newCustomer);
    _customerList =
        swingBox.values.whereType<Customer>().cast<Customer>().toList();
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
      {required BuildContext context, required Customer customer}) async{
    await swingBox.delete(customer.id);
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

  // getting target customer out of list
  Customer customer(String customerId){
    return _customerList.firstWhere((foundCustomer) => foundCustomer.id == customerId);
    notifyListeners();
  }

  // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  void filterValues({required String? value,required String customerId}) async {
    switch (value) {
      case 'All':
        _customerOrders = customer(customerId).customerOrder;
        notifyListeners();
        break;
      case 'Swen NOT Delivered':
        _customerOrders = customer(customerId).customerOrder.where(
              (foundOrder) => foundOrder.isDone == true && foundOrder.isDelivered == false).toList();
        print('########S N D######## ${_customerOrders}');
        notifyListeners();
        break;
      case 'Sewn & Delivered':
        _customerOrders = customer(customerId).customerOrder
            .where((foundOrder) => foundOrder.isDelivered == true && foundOrder.isDone == true).toList();
        print('######## S  D ######## ${_customerOrders}');
        notifyListeners();
        break;
      case 'In Progress':
        _customerOrders = customer(customerId).customerOrder.where((foundOrder) =>
        foundOrder.isDone == false && foundOrder.isDelivered == false).toList();
        print('######## In Progress ######## ${_customerOrders}');
        notifyListeners();
        break;
    }
  }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  void onChangeDropdownFilterValue({required String? newValue, required
  String customerId}) async {
    if (newValue != null) {
        _selectedFilter = newValue;
        filterValues(value: newValue,customerId: customerId);
      await swingBox.put('filterValueKey', newValue);
    notifyListeners();
    }
  }

  // filter in customer profile
  List<PopupMenuEntry<String>> orderStatusSelection(
      {required BuildContext context, required Order order,required String
      customerId}) {
    return [
        PopupMenuItem<String>(
            value: selectableOrderStatus[1],
            onTap: () {
              onChangeDropdownFilterValue(newValue: selectableOrderStatus[1],
                customerId: customerId);
             notifyListeners();
            },
            child: Text(selectableOrderStatus[1])),
        PopupMenuItem<String>(
          onTap: () {
            onChangeDropdownFilterValue(newValue: selectableOrderStatus[2],
                customerId: customerId);
            notifyListeners();
          },
          value: selectableOrderStatus[2],
          child: Text(selectableOrderStatus[2]),
        ),
        PopupMenuItem<String>(
          onTap: () {
            onChangeDropdownFilterValue(newValue: selectableOrderStatus[0],
                customerId: customerId);
            notifyListeners();
          },
          value: selectableOrderStatus[0],
          child: Text(selectableOrderStatus[0]),
        )
      ];
  }


}
