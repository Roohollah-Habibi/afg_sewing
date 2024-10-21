import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
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
    'All',
    'Done',
    'Delivered',
    'In Progress'
  ];
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    customer = swingBox.get(widget.customerId);
    customerOrders = customer.customerOrder;
  }

  void filterValues(String? value) {
    switch (value) {
      case 'All':
        customerOrders = customer.customerOrder;
        print('================ ALL ========================');
      case 'Done':
        customerOrders = customer.customerOrder
            .where(
              (foundOrder) => foundOrder.isDone == true,
            )
            .toList();
        print('================ DONE ========================');
      case 'Delivered':
        customerOrders = customer.customerOrder
            .where(
              (foundOrder) => foundOrder.isDelivered == true,
            )
            .toList();
        print('================ DELIVERED ========================');
      case 'In Progress':
        customerOrders = customer.customerOrder
            .where(
              (foundOrder) => foundOrder.isDone == false,
            )
            .toList();
        print('================ IN PROGRESS ========================');
      default:
        customerOrders = customer.customerOrder;
    }
  }

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
        actions: [
          const Text(
            'Filter by:',
            style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
          DropdownButton<String>(
            padding: const EdgeInsets.only(right: 30),
            icon: const Icon(Icons.filter_alt),
            alignment: Alignment.center,
            iconSize: 30,
            value: selectedFilter,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedFilter = newValue;
                  filterValues(newValue);
                });
              }
            },
            items: filterOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
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
                                customerOrders.removeAt(index);
                              });
                              Customer.updateOrderList(
                                  customer: customer,
                                  newOrderList: customerOrders);
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
                                onLongPress: () async => await showDialog(
                                  context: context,
                                  builder: (context) =>
                                      buildAlertDialog(customerOrders[index]),
                                ),
                                trailing: (customerOrders[index].isDone &&
                                        customerOrders[index].isDelivered)
                                    ? Icon(
                                        Icons.monetization_on_outlined,
                                        color: Colors.green[700],
                                      )
                                    : customerOrders[index].isDone
                                        ? const Icon(Icons.check_circle_outline,
                                            color: Colors.indigo)
                                        : const Icon(
                                            Icons.timer_outlined,
                                            color: Colors.red,
                                          ),
                                title: Text(
                                  'ID: ${customerOrders[index].id.substring(customerOrders[index].id.length - 5)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green),
                                ),
                                subtitle: Text(
                                  '${customerOrders[index].deliveryDate.day}-${customerOrders[index].deliveryDate.month}-${customerOrders[index].deliveryDate.year}',
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

  Widget buildAlertDialog(Order orderStatus) {
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      title: const Icon(Icons.warning_amber, color: Colors.yellow, size: 100),
      content: const Text('Are you paid? ',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
      actions: [
        TextButton.icon(
          onPressed: () {
            orderStatus.isDelivered = true;
            orderStatus.isDone = true;
            Customer.addNewOrder(
                newOrder: orderStatus,
                customerId: customer.id,
                replaceOrderId: orderStatus.id);
            print('============ ALERT SHOULD YES =============');
            setState(() {customerOrders = customer.customerOrder;});
            Navigator.of(context).pop();
          },
          label: Text('YES', style: alertActionButtonStyles),
        ),
        TextButton.icon(
          onPressed: () {
            print('============ ALERT SHOULD POP =============');
            Navigator.of(context).pop();
          },
          label: Text('NO', style: alertActionButtonStyles),
        ),
        TextButton.icon(
          onPressed: () {
            orderStatus.isDelivered = false;
            Customer.addNewOrder(
                newOrder: orderStatus,
                customerId: customer.id,
                replaceOrderId: orderStatus.id);
            print('============ ALERT SHOULD UNDO =============');
            Navigator.of(context).pop();
            setState(() {});
          },
          label: Text('Undo', style: alertActionButtonStyles),
        ),
      ],
    );
  }
}
