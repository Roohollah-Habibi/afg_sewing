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
  late Customer customer;
  late List<Order>? customerOrders;

  @override
  void initState() {
    super.initState();
    customer = swingBox.get(widget.customerId);
    customerOrders = customer.customerOrder ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                Text(
                  'Phone:${customer.phoneNumber1}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Phone:${(customer.phoneNumber2!.isEmpty)? 'Not available' : customer.phoneNumber2!}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            Expanded(
              child: Center(
                child: customerOrders!.isEmpty
                    ? Text('No available Order for ${customer.firstName}')
                    : ListView.builder(
                        itemCount: customerOrders?.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(customerOrders![index].model),
                              subtitle: Text(customerOrders![index].parcha),
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
          Navigator.of(context).pushNamed(RouteManager.orderPage);
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
