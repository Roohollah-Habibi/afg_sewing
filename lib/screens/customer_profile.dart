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
  final Box swingBox = Hive.box(swingDb);
  late final Customer customer;
  late final List<Order> customerOrders;

  @override
  void initState() {
    super.initState();
    customer = swingBox.get(widget.customerId);
    customerOrders = customer.customerOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.of(context).pushReplacementNamed(
              RouteManager.root);
        }, icon: const Icon(Icons.arrow_back)),
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
                          builder: (context) =>
                              AlertDialog(
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
                          title: Text(customerOrders[index].qad),
                          subtitle: Text(
                              '${customerOrders[index].remainingMoney}'),
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
              arguments: {'id': customer.id});
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
