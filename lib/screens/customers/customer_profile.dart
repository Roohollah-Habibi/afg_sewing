import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/providers/order_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const String swingDb = 'SwingDb';

class CustomerProfile extends StatefulWidget {
  final String customerId;

  const CustomerProfile({super.key, required this.customerId});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {

  // late final Customer customer;
  // late List<Order> customerOrders;
  // final List<String> filterOptions = [
  //   'In Progress',
  //   'Swen NOT Delivered',
  //   'Sewn & Delivered',
  //   'All'
  // ];
  // final List<String> selectableOrderStatus = [
  //   'In Progress',
  //   'Swen NOT Delivered',
  //   'Sewn & Delivered',
  // ];
  // late String? selectedFilter;

  @override
  void initState() {
    super.initState();
    // customer = swingBox.get(widget.customerId);
    // customerOrders = customer.customerOrder;
    // selectedFilter = swingBox.get('filterValueKey') ?? 'All';
    // filterValues(selectedFilter);
  }

  // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  // void filterValues(String? value) async {
  //   switch (value) {
  //     case 'All':
  //       customerOrders = customer.customerOrder;
  //       break;
  //     case 'Swen NOT Delivered':
  //       customerOrders = customer.customerOrder.where(
  //         (foundOrder) {
  //           return foundOrder.isDone == true && foundOrder.isDelivered == false;
  //         },
  //       ).toList();
  //       break;
  //     case 'Sewn & Delivered':
  //       customerOrders = customer.customerOrder
  //           .where(
  //             (foundOrder) =>
  //                 foundOrder.isDelivered == true && foundOrder.isDone == true,
  //           )
  //           .toList();
  //       break;
  //     case 'In Progress':
  //       customerOrders = customer.customerOrder
  //           .where((foundOrder) =>
  //               foundOrder.isDone == false && foundOrder.isDelivered == false)
  //           .toList();
  //       break;
  //   }
  //   setState(() {});
  // }

  // CHANGE THE ORDER STATUS [Swen NOT Delivered , Sewn & Delivered , In Progress]
  // void changeOrderStatusValues(
  //     {required String value, required Order selectedOrder}) {
  //   switch (value) {
  //     case 'Swen NOT Delivered':
  //       selectedOrder.isDone = true;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: customer.id,
  //           replaceOrderId: selectedOrder.id);
  //
  //     case 'Sewn & Delivered':
  //       selectedOrder.isDone = true;
  //       selectedOrder.isDelivered = true;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: customer.id,
  //           replaceOrderId: selectedOrder.id);
  //
  //     case 'In Progress':
  //       selectedOrder.isDone = false;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: customer.id,
  //           replaceOrderId: selectedOrder.id);
  //
  //     default:
  //       selectedOrder.isDone = false;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: customer.id,
  //           replaceOrderId: selectedOrder.id);
  //   }
  //   onChangeDropdownFilterValue(selectedFilter);
  // }
  //
  // void onChangeDropdownFilterValue(String? newValue) async {
  //   if (newValue != null) {
  //     setState(() {
  //       selectedFilter = newValue;
  //       filterValues(newValue);
  //     });
  //     await swingBox.put('filterValueKey', newValue);
  //   }
  // }
  //
  // List<PopupMenuEntry<String>> orderStatusSelection(
  //         BuildContext context, Order order) => [
  //       PopupMenuItem<String>(
  //           onTap: () {
  //             changeOrderStatusValues(
  //                 value: selectableOrderStatus[1], selectedOrder: order);
  //             setState(() {});
  //             print('============ ${selectableOrderStatus[1]}==============');
  //           },
  //           child: Text('Swen NOT Delivered'),
  //           value: selectableOrderStatus[1]),
  //       PopupMenuItem<String>(
  //         onTap: () {
  //           changeOrderStatusValues(
  //               value: selectableOrderStatus[2], selectedOrder: order);
  //           print('============ ${selectableOrderStatus[2]}==============');
  //           setState(() {});
  //         },
  //         child: Text('Sewn & Delivered'),
  //         value: selectableOrderStatus[2],
  //       ),
  //       PopupMenuItem<String>(
  //         onTap: () {
  //           changeOrderStatusValues(
  //               value: selectableOrderStatus[0], selectedOrder: order);
  //           print('============ ${selectableOrderStatus[0]}==============');
  //           setState(() {});
  //         },
  //         child: Text('In Progress'),
  //         value: selectableOrderStatus[0],
  //       ),
  //     ];

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
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteManager.orderPage,
              arguments: {'customerId': widget.customerId, 'orderId': ''});
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          final customerProvider = Provider.of<CustomerProvider>(context);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '${customerProvider.customer(widget.customerId).firstName}'
                  '\t${customerProvider.customer(widget.customerId).lastName}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'ID: ${customerProvider.customer(widget.customerId).id}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildPhoneCard(
                          phoneNumber: customerProvider
                              .customer(widget.customerId)
                              .phoneNumber1),
                      buildPhoneCard(
                          phoneNumber: customerProvider
                              .customer(widget.customerId)
                              .phoneNumber2),
                    ]),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          'Orders: ${customerProvider.customer(widget.customerId).customerOrder.length}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      icon: const Icon(Icons.filter_alt),
                      alignment: Alignment.center,
                      iconSize: 30,
                      value: customerProvider.getSelectedFilter,
                      onChanged: (value) =>
                          customerProvider.onChangeDropdownFilterValue(
                              newValue: value, customerId: widget.customerId),
                      items: customerProvider.filterOptions
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
                    child: customerProvider
                            .getOrders
                            .isEmpty
                        ? Text(textAlign: TextAlign.center,
                            'No available Order for ${customerProvider
                                .customer(widget.customerId).firstName} to '
                                'this filter option')
                        : ListView.builder(
                            itemCount: customerProvider
                                .customer(widget.customerId)
                                .customerOrder
                                .length,
                            itemBuilder: (context, index) {
                              Order order = customerProvider.customer(widget
                                  .customerId).customerOrder[index];
                              return Dismissible(
                                key: Key(order.id),
                                onDismissed: (direction) {
                                  customerProvider.getOrders.removeWhere(
                                    (element) => element.id == order.id,
                                  );
                                  Customer.removeOrder(
                                      customerId: widget.customerId,
                                      removableOrder: order);
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      action: SnackBarAction(
                                        label: 'Undo',
                                        onPressed: () async {
                                          customerProvider.getOrders.add(order);
                                          await Customer.updateOrderList(
                                              customer: customerProvider
                                                  .customer(widget.customerId),
                                              newOrderList:
                                                  customerProvider.getOrders);
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
                                  color: customerProvider.deadlineColor(
                                      order,
                                      Colors.white70,
                                      Colors.red.shade200,
                                      Colors.orange.shade200),
                                  child: ListTile(
                                    tileColor: customerProvider.deadlineColor(
                                        order,
                                        AppColorsAndThemes.subPrimaryColor,
                                        Colors.red.shade200,
                                        Colors.orange.shade200),
                                    onTap: () => Navigator.of(context)
                                        .pushNamed(RouteManager.orderPage,
                                            arguments: {
                                          'customerId': widget.customerId,
                                          'orderId': order.id
                                        }),
                                    trailing: PopupMenuButton(
                                        itemBuilder: (context) =>
                                            customerProvider.orderStatusSelection(
                                                    context: context,
                                                    order: order,
                                                    customerId:
                                                        widget.customerId)),
                                    title: Text(
                                      'ID: ${order.id}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.indigo.shade900),
                                    ),
                                    subtitle: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const Icon(
                                              Icons.note_alt_outlined),
                                          title: Text(
                                            'Reg: ${order.registeredDate
                                                .day}-${order.registeredDate
                                                .month}-${order.registeredDate
                                                .year}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          tileColor:
                                              customerProvider.deadlineColor(
                                                  order,
                                                  AppColorsAndThemes
                                                      .subPrimaryColor,
                                                  Colors.red.shade200,
                                                  Colors.orange.shade200),
                                        ),
                                        ListTile(
                                          tileColor:
                                              customerProvider.deadlineColor(
                                                  order,
                                                  AppColorsAndThemes
                                                      .subPrimaryColor,
                                                  Colors.red.shade200,
                                                  Colors.orange.shade200),
                                          leading:
                                              const Icon(CupertinoIcons.flag),
                                          title: Text(
                                            'DL: ${order.deadLineDate
                                                .day}-${order.deadLineDate
                                                .month}-${order.deadLineDate
                                                .year}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: customerProvider.deadlineFont(order),
                                              color: customerProvider.deadlineColor(
                                                      order,
                                                      AppColorsAndThemes
                                                          .secondaryColor,
                                                      Colors.redAccent,
                                                      Colors.red.shade900),
                                            ),
                                          ),
                                        )
                                      ],
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
          );
        },
      ),
    );
  }



  Widget buildPhoneCard({required String phoneNumber}) {
    return Expanded(
      child: Card(
        color: Colors.white54,
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 3),
          leading: const Icon(
            Icons.phone_android,
            color: Colors.black45,
          ),
          title: Text(
            phoneNumber.length > 2 ? phoneNumber : 'Not Available',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
