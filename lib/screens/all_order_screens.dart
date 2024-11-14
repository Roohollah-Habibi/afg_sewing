
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
const String swingDb = 'SwingDb';

class AllOrderScreens extends StatefulWidget {
  const AllOrderScreens({super.key});

  @override
  State<AllOrderScreens> createState() => _AllOrderScreensState();
}

class _AllOrderScreensState extends State<AllOrderScreens> {
  final Box swingBox = Hive.box(swingDb);
  late List<Order> allOrders;
  late List<Customer> allCustomers;
  final List<String> selectableOrderStatus = [
    'In Progress',
    'Swen NOT Delivered',
    'Sewn & Delivered',
  ];
  final List<String> filterOptions = [
    'In Progress',
    'Swen NOT Delivered',
    'Sewn & Delivered',
    'expired',
    '2 days left',
    'just today',
    'All'
  ];
  late String? selectedFilter;

  @override
  void initState() {
    super.initState();
    allCustomers =
        swingBox.values.whereType<Customer>().toList().cast<Customer>();
    allOrders = [for (var order in allCustomers) ...order.customerOrder];
    selectedFilter = swingBox.get('filterValueKey') ?? 'In Progress';
    filterValues(selectedFilter);
  }

  void changeOrderStatusValues(
      {required String value, required Order selectedOrder}){
    switch (value) {
      case 'Swen NOT Delivered':
        selectedOrder.isDone = true;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: selectedOrder.customerId,
            replaceOrderId: selectedOrder.id);

      case 'Sewn & Delivered':
        selectedOrder.isDone = true;
        selectedOrder.isDelivered = true;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: selectedOrder.customerId,
            replaceOrderId: selectedOrder.id);

      case 'In Progress':
        selectedOrder.isDone = false;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: selectedOrder.customerId,
            replaceOrderId: selectedOrder.id);

      default:
        selectedOrder.isDone = false;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: selectedOrder.customerId,
            replaceOrderId: selectedOrder.id);
    }
    onChangeDropdownFilterValue(selectedFilter);
  }

  List<PopupMenuEntry<String>> orderStatusSelection(
          BuildContext context, Order order) =>
      [
        PopupMenuItem<String>(
            onTap: () {
              changeOrderStatusValues(
                  value: selectableOrderStatus[1], selectedOrder: order);
              setState(() {});
            },
            value: selectableOrderStatus[1],
            child: const Text('Swen NOT Delivered')),
        PopupMenuItem<String>(
          onTap: () {
            changeOrderStatusValues(
                value: selectableOrderStatus[2], selectedOrder: order);
            setState(() {});
          },
          value: selectableOrderStatus[2],
          child: const Text('Sewn & Delivered'),
        ),
        PopupMenuItem<String>(
          onTap: () {
            changeOrderStatusValues(
                value: selectableOrderStatus[0], selectedOrder: order);
            setState(() {});
          },
          value: selectableOrderStatus[0],
          child: const Text('In Progress'),
        ),
      ];

  // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  void filterValues(String? value) async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final today = DateFormat('yyyy-MM-dd').parse(todayStr);
    List<Order> tempOrder = [
      for (var order in allCustomers) ...order.customerOrder
    ];
    switch (value) {
      case 'All':
        allOrders = tempOrder;
        break;
      case 'Swen NOT Delivered':
        allOrders = tempOrder
            .where(
              (foundOrder) =>
                  foundOrder.isDone == true && foundOrder.isDelivered == false,
            )
            .toList();
        break;
      case 'Sewn & Delivered':
        allOrders = tempOrder
            .where(
              (foundOrder) =>
                  foundOrder.isDelivered == true && foundOrder.isDone == true,
            )
            .toList();
        break;
      case 'In Progress':
        allOrders = tempOrder
            .where((foundOrder) =>
                foundOrder.isDone == false && foundOrder.isDelivered == false)
            .toList();
        break;
      case 'expired':
        allOrders = tempOrder.where((foundOrder) {
          return foundOrder.registeredDate.isAfter(foundOrder.deadLineDate);
        },).toList();
        break;
        case 'just today':
        allOrders = tempOrder.where((foundOrder) => foundOrder.deadLineDate.isAtSameMomentAs(today)).toList();
        break;
        case '2 days left':
        allOrders = tempOrder.where((foundOrder) => foundOrder.deadLineDate.subtract(const Duration(days: 2)).isAtSameMomentAs(today)).toList();
        break;


    }
    setState(() {});
  }

  void onChangeDropdownFilterValue(String? newValue) async {
    if (newValue != null) {
      setState(() {
        selectedFilter = newValue;
      });
      await swingBox.put('filterValueKey', newValue);
      filterValues(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed(RouteManager.root),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('All Orders'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Orders: ${allOrders.length}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    icon: const Icon(Icons.filter_alt),
                    alignment: Alignment.center,
                    iconSize: 30,
                    value: selectedFilter,
                    onChanged: onChangeDropdownFilterValue,
                    items: filterOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          allOrders.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'No Order is Available',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.indigo),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: allOrders.length,
                    itemBuilder: (context, index) {
                      final Order order = allOrders[index];
                      Customer myCustomer = allCustomers.firstWhere(
                        (element) => element.id == order.customerId,
                      );
                      return buildCard(context,
                          customerName: myCustomer.firstName,
                          customerLastName: myCustomer.lastName,
                          registeredDate: order.registeredDate,
                          deadLine: order.deadLineDate,
                          orderId: order.id,
                          customerId: myCustomer.id);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context,
      {required String customerName,
      required String customerLastName,
      required String orderId,
      required DateTime registeredDate,
      required DateTime deadLine,
      required String customerId}) {
    return Card(
      color: Colors.white10,
      child: ListTile(
        trailing: PopupMenuButton(
          itemBuilder: (context) =>
              orderStatusSelection(context, Order.fromId(orderId: orderId,customerId: customerId)),
        ),
        title: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                )
              ],
              borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
          // margin: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 50 / 100,
          height: MediaQuery.of(context).size.width * 50 / 100,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                    RouteManager.customerProfile,
                    arguments: {'id': customerId}),
                child: Text(
                  '$customerName $customerLastName',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed(
                    RouteManager.orderPage,
                    arguments: {'customerId': customerId, 'orderId': orderId}),
                child: Text(
                  orderId,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green),
                ),
              ),
              Text(
                  'Registered: ${registeredDate.year}/${registeredDate.month}/${registeredDate.day}',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
              Text(
                  'DeadLine : ${deadLine.year}/${deadLine.month}/${deadLine.day}',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
              Flexible(
                child: Text(
                    'Days Left: ${deadLine.difference(registeredDate).inDays}',style: const TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
