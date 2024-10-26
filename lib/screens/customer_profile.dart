import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String swingDb = 'SwingDb';

class CustomerProfile extends StatefulWidget {
  final String customerId;

  const CustomerProfile({super.key, required this.customerId});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final TextStyle alertActionButtonStyles =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  final Box swingBox = Hive.box(swingDb);
  late final Customer customer;
  late List<Order> customerOrders;
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
  late String? selectedFilter;


  @override
  void initState() {
    super.initState();
    customer = swingBox.get(widget.customerId);
    customerOrders = customer.customerOrder;
    selectedFilter = swingBox.get('filterValueKey') ?? 'All';
    filterValues(selectedFilter);
  }

  // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  void filterValues(String? value) async {
    switch (value) {
      case 'All':
        customerOrders = customer.customerOrder;
        break;
      case 'Swen NOT Delivered':
        customerOrders = customer.customerOrder.where(
          (foundOrder) {
            return foundOrder.isDone == true && foundOrder.isDelivered == false;
          },
        ).toList();
        break;
      case 'Sewn & Delivered':
        customerOrders = customer.customerOrder
            .where(
              (foundOrder) =>
                  foundOrder.isDelivered == true && foundOrder.isDone == true,
            )
            .toList();
        break;
      case 'In Progress':
        customerOrders = customer.customerOrder
            .where((foundOrder) =>
                foundOrder.isDone == false && foundOrder.isDelivered == false)
            .toList();
        break;
    }
    setState(() {});
  }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  void changeOrderStatusValues(
      {required String value, required Order selectedOrder}) {
    switch (value) {
      case 'Swen NOT Delivered':
        selectedOrder.isDone = true;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: customer.id,
            replaceOrderId: selectedOrder.id);

      case 'Sewn & Delivered':
        selectedOrder.isDone = true;
        selectedOrder.isDelivered = true;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: customer.id,
            replaceOrderId: selectedOrder.id);

      case 'In Progress':
        selectedOrder.isDone = false;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: customer.id,
            replaceOrderId: selectedOrder.id);

      default:
        selectedOrder.isDone = false;
        selectedOrder.isDelivered = false;
        Customer.addNewOrder(
            newOrder: selectedOrder,
            customerId: customer.id,
            replaceOrderId: selectedOrder.id);
    }
    onChangeDropdownFilterValue(selectedFilter);
  }

  void onChangeDropdownFilterValue(String? newValue) async {
    if (newValue != null) {
      setState(() {
        selectedFilter = newValue;
        filterValues(newValue);
      });
      await swingBox.put('filterValueKey', newValue);
    }
  }

  List<PopupMenuEntry<String>> orderStatusSelection(
          BuildContext context, Order order) =>
      [
        PopupMenuItem<String>(
            onTap: () {
              changeOrderStatusValues(
                  value: selectableOrderStatus[1], selectedOrder: order);
              setState(() {});
              print('============ ${selectableOrderStatus[1]}==============');
            },
            child: Text('Swen NOT Delivered'),
            value: selectableOrderStatus[1]),
        PopupMenuItem<String>(
          onTap: () {
            changeOrderStatusValues(
                value: selectableOrderStatus[2], selectedOrder: order);
            print('============ ${selectableOrderStatus[2]}==============');
            setState(() {});
          },
          child: Text('Sewn & Delivered'),
          value: selectableOrderStatus[2],
        ),
        PopupMenuItem<String>(
          onTap: () {
            changeOrderStatusValues(
                value: selectableOrderStatus[0], selectedOrder: order);
            print('============ ${selectableOrderStatus[0]}==============');
            setState(() {});
          },
          child: Text('In Progress'),
          value: selectableOrderStatus[0],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteManager.customers);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              customer.firstName,
              style: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              customer.lastName,
              style: TextStyle(
                fontSize: 25,
                color: Colors.grey[700],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.lightBlueAccent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone_android,
                        color: Colors.blue,
                      ),
                      title: Text(customer.phoneNumber1),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.lightBlueAccent,
                    child: ListTile(
                      leading: const Icon(
                        Icons.phone_android,
                        color: Colors.blue,
                      ),
                      title: Text(customer.phoneNumber2.isNotEmpty
                          ? customer.phoneNumber2
                          : 'Not Available'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Total Orders: ${customerOrders.length}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DropdownButton<String>(
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
              ],
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: customerOrders.isEmpty
                    ? Text('No available Order for ${customer.firstName}')
                    : ListView.builder(
                        itemCount: customerOrders.length,
                        itemBuilder: (context, index) {
                          Order order = customerOrders[index];

                          return Dismissible(
                            key: Key(order.id),
                            onDismissed: (direction) {
                              setState(() {
                                customerOrders.removeWhere((element) => element.id == order.id,);
                                Customer.removeOrder(customerId: widget.customerId, removableOrder: order);
                              });
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: () async {
                                      setState(() {
                                        customerOrders.add(order);
                                      });
                                      await Customer.updateOrderList(
                                          customer: customer,
                                          newOrderList: customerOrders);
                                    },
                                  ),
                                  content: const Text(
                                      'Order is removed successfully'),
                                ),
                              );
                            },
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Icon(
                                    Icons.warning_amber_outlined,
                                    size: 100,
                                  ),
                                  alignment: Alignment.center,
                                  content: const Text(
                                    'Are you sure you wanna remove the order?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.center,
                              child: const Text(
                                'order removed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            direction: DismissDirection.endToStart,
                            child: Card(
                              child: ListTile(
                                onTap: () => Navigator.of(context).pushNamed(
                                    RouteManager.orderPage,
                                    arguments: {
                                      'customerId': widget.customerId,
                                      'orderId': customerOrders[index].id
                                    }),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) =>
                                      orderStatusSelection(context, order),
                                ),
                                title: Text(
                                  'ID: ${customerOrders[index].id.substring(customerOrders[index].id.length - 5)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green),
                                ),
                                subtitle: Text(
                                  '${customerOrders[index].deadLineDate.day}-${customerOrders[index].deadLineDate.month}-${customerOrders[index].deadLineDate.year}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(RouteManager.orderPage,
              arguments: {'customerId': customer.id, 'orderId': ''});
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
