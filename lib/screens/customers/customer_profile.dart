import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/providers/order_provider.dart';
import 'package:afg_sewing/screens/reports.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${customerProvider.customer(widget.customerId).firstName}'
                  '\t${customerProvider.customer(widget.customerId).lastName}',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  'ID: ${customerProvider.customer(widget.customerId).id}',
                  style: Theme.of(context).textTheme.bodyMedium,
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
                    // DropdownButton<String>(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10),
                    //   icon: const Icon(Icons.filter_alt),
                    //   alignment: Alignment.center,
                    //   iconSize: 30,
                    //   value: customerProvider.getSelectedFilter,
                    //   items: customerProvider.filterOptions
                    //       .map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) =>
                    //       customerProvider.onChangeFilterValue(newValue: value, customerId: widget.customerId),
                    // ),
                  ],
                ),
                const Divider(),
                Expanded(
                  child: Center(
                    child: customerProvider.getOrders.isEmpty
                        ? Text(
                            textAlign: TextAlign.center,
                            'No available Order for ${customerProvider.customer(widget.customerId).firstName} to '
                            'this filter option')
                        : ListView.builder(
                            itemCount: customerProvider
                                .customer(widget.customerId)
                                .customerOrder
                                .length,
                            itemBuilder: (context, index) {
                              Order order = customerProvider
                                  .customer(widget.customerId)
                                  .customerOrder[index];
                              String betterFormatedRegisteredDate =
                                  customerProvider
                                      .betterFormatedDate(order.registeredDate);
                              String betterFormatedDeadlineDate =
                                  customerProvider
                                      .betterFormatedDate(order.deadLineDate);
                              //             return Dismissible(
                              //               key: Key(order.id),
                              //               onDismissed: (direction) {
                              //                 customerProvider.getOrders.removeWhere(
                              //                   (element) => element.id == order.id,
                              //                 );
                              //                 Customer.removeOrder(
                              //                     customerId: widget.customerId,
                              //                     removableOrder: order);
                              //                 ScaffoldMessenger.of(context)
                              //                     .hideCurrentSnackBar();
                              //                 ScaffoldMessenger.of(context).showSnackBar(
                              //                   SnackBar(
                              //                     action: SnackBarAction(
                              //                       label: 'Undo',
                              //                       onPressed: () async {
                              //                         customerProvider.getOrders.add(order);
                              //                         await Customer.updateOrderList(
                              //                             customer: customerProvider
                              //                                 .customer(widget.customerId),
                              //                             newOrderList:
                              //                                 customerProvider.getOrders);
                              //                       },
                              //                     ),
                              //                     content: const Text(
                              //                         'Order is removed successfully'),
                              //                   ),
                              //                 );
                              //               },
                              //               confirmDismiss: (direction) async {
                              //                 return await showDialog(
                              //                   context: context,
                              //                   builder: (context) => AlertDialog(
                              //                     title: const Icon(
                              //                       Icons.warning_amber_outlined,
                              //                       size: 100,
                              //                     ),
                              //                     alignment: Alignment.center,
                              //                     content: const Text(
                              //                       'Are you sure you wanna remove the order?',
                              //                       textAlign: TextAlign.center,
                              //                     ),
                              //                     actions: [
                              //                       TextButton(
                              //                         onPressed: () =>
                              //                             Navigator.of(context).pop(false),
                              //                         child: const Text('Cancel'),
                              //                       ),
                              //                       TextButton(
                              //                         onPressed: () =>
                              //                             Navigator.of(context).pop(true),
                              //                         child: const Text('Delete'),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               background: Container(
                              //                 color: Colors.red,
                              //                 alignment: Alignment.center,
                              //                 child: const Text(
                              //                   'order removed',
                              //                   style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 20,
                              //                   ),
                              //                 ),
                              //               ),
                              //               direction: DismissDirection.endToStart,
                              //               child:
                              return buildCardListView(
                                order: order,
                                provider: customerProvider,
                                registerDate: betterFormatedRegisteredDate,
                                deadline: betterFormatedDeadlineDate,
                                // popUp: Icon(Icons.phone_android)
                              );
                              //                     Card(
                              //                 color: customerProvider.deadlineColor(
                              //                     order,
                              //                     Colors.white70,
                              //                     Colors.red.shade200,
                              //                     Colors.orange.shade200),
                              //                 child: ListTile(
                              //                   tileColor: customerProvider.deadlineColor(
                              //                       order,
                              //                       AppColorsAndThemes.subPrimaryColor,
                              //                       Colors.red.shade200,
                              //                       Colors.orange.shade200),
                              //                   minVerticalPadding: 0,
                              //                   onTap: () => Navigator.of(context)
                              //                       .pushNamed(RouteManager.orderPage,
                              //                           arguments: {
                              //                         'customerId': widget.customerId,
                              //                         'orderId': order.id
                              //                       }),
                              //                   trailing: PopupMenuButton(
                              //                     itemBuilder: (context) =>
                              //                         customerProvider.orderStatusSelection(
                              //                             context: context,
                              //                             // order: order,
                              //                             customerId: widget.customerId),
                              //                   ),
                              //                   subtitle: Column(
                              //                     mainAxisSize: MainAxisSize.min,
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment.start,
                              //                     children: [
                              //                       ListTile(
                              //                         leading: const Icon(
                              //                             Icons.note_alt_outlined),
                              //                         title: Text(
                              //                           'Reg: ${order.registeredDate.day}-${order.registeredDate.month}-${order.registeredDate.year}',
                              //                           style: const TextStyle(
                              //                               fontWeight: FontWeight.bold,
                              //                               fontSize: 16),
                              //                         ),
                              //                         tileColor:
                              //                             customerProvider.deadlineColor(
                              //                                 order,
                              //                                 AppColorsAndThemes
                              //                                     .subPrimaryColor,
                              //                                 Colors.red.shade200,
                              //                                 Colors.orange.shade200),
                              //                       ),
                              //                       ListTile(
                              //                         tileColor:
                              //                             customerProvider.deadlineColor(
                              //                                 order,
                              //                                 AppColorsAndThemes
                              //                                     .subPrimaryColor,
                              //                                 Colors.red.shade200,
                              //                                 Colors.orange.shade200),
                              //                         leading:
                              //                             const Icon(CupertinoIcons.flag),
                              //                         title: Text(
                              //                           'DL: ${order.deadLineDate.day}-${order.deadLineDate.month}-${order.deadLineDate.year}',
                              //                           style: TextStyle(
                              //                             fontWeight: FontWeight.bold,
                              //                             fontSize: customerProvider
                              //                                 .deadlineFont(order),
                              //                             color: customerProvider
                              //                                 .deadlineColor(
                              //                                     order,
                              //                                     AppColorsAndThemes
                              //                                         .secondaryColor,
                              //                                     Colors.redAccent,
                              //                                     Colors.red.shade900),
                              //                           ),
                              //                         ),
                              //                       )
                              //                     ],
                              //                   ),
                              // //                 ),
                              //               ),
                              //             );
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

  Widget buildCardListView(
      {required CustomerProvider provider,
      required String registerDate,
      required String deadline,
      required Order order}) {
    return Card(
      elevation: 5,
      shadowColor: AppColorsAndThemes.secondaryColor,
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(RouteManager.orderPage,
            arguments: {'customerId': widget.customerId, 'orderId': order.id}),
        leading: Icon(
          Icons.circle,
          color: provider.circleMatchWithPopupValueColor(order: order),
        ),
        trailing: CustomPopupMenuButton(
          order: order,
          provider: provider,
          customer: provider.customer(widget.customerId),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SimpleRowForTextIcon(
                text: registerDate,
                icon: const Icon(
                  Icons.calendar_month,
                )),
            const SizedBox(height: 20),
            _SimpleRowForTextIcon(
              text: deadline,
              icon: const Icon(
                Icons.alarm,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// custom popup menu to show [swen, delivered , in progress]
class CustomPopupMenuButton extends StatelessWidget {
  final String sewnNotDelivered = 'Sewn NOT delivered';
  final String sewnAndDelivered = 'Sewn & delivered';
  final String inProgress = 'In progress';
  final Order order;
  final CustomerProvider provider;
  final Customer customer;

  const CustomPopupMenuButton(
      {super.key,
      required this.order,
      required this.customer,
      required this.provider});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: sewnNotDelivered,
          onTap: () => provider.onPopupMenu(
              order: order, value: sewnNotDelivered, customer: customer),
          child: _SimpleRowForTextIcon(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              text: sewnNotDelivered,
              icon: const Icon(Icons.circle,
                  color: AppColorsAndThemes.secondaryColor),
              firstIconThenText: false),
        ),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: sewnAndDelivered,
          onTap: () => provider.onPopupMenu(
              order: order, value: sewnAndDelivered, customer: customer),
          child: _SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: sewnAndDelivered,
            icon: Icon(
              Icons.circle,
              color: Colors.green[800],
            ),
            firstIconThenText: false,
          ),
        ),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: inProgress,
          onTap: () => provider.onPopupMenu(
              order: order, value: inProgress, customer: customer),
          child: _SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: inProgress,
            icon: Icon(Icons.circle, color: Colors.orange.shade700),
            firstIconThenText: false,
          ),
        ),
      ];
    });
  }
}

// Simple row to show icon and date next to each other
class _SimpleRowForTextIcon extends StatelessWidget {
  final String text;
  final Icon icon;
  final bool firstIconThenText;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const _SimpleRowForTextIcon(
      {super.key,
      required this.text,
      required this.icon,
      this.firstIconThenText = true,
      this.mainAxisAlignment = MainAxisAlignment.start,
      this.crossAxisAlignment = CrossAxisAlignment.start,
      this.mainAxisSize = MainAxisSize.min});

  @override
  Widget build(BuildContext context) {
    return firstIconThenText
        ? Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              icon,
              const SizedBox(width: 15),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          )
        : Row(
            mainAxisSize: mainAxisSize,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Text(text),
              const SizedBox(width: 15),
              icon,
            ],
          );
  }
}

// show card for user phones
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
