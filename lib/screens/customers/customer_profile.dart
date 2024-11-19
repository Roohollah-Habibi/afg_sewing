import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CustomerProfile extends StatefulWidget {
  final String customerId;

  const CustomerProfile({super.key, required this.customerId});

  @override
  State<CustomerProfile> createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  @override
  void initState() {
    super.initState();
    context.read<CustomerProvider>().filterValues(
        value: context.read<CustomerProvider>().getSelectedFilter, shouldNotify: false, customerId: widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed(RouteManager.orderPage, arguments: {'customerId': widget.customerId, 'orderId': ''}).then(
            (value) => setState(() {}),
          );
          // Provider.of<CustomerProvider>(context,listen: false).setOrderTimes(orderId: '',customerId: widget.customerId);
        },
        label: const Text('New Order'),
        icon: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          final customerProvider = Provider.of<CustomerProvider>(context);
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 60),
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
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _buildPhoneCard(phoneNumber: customerProvider.customer(widget.customerId).phoneNumber1),
                  _buildPhoneCard(phoneNumber: customerProvider.customer(widget.customerId).phoneNumber2),
                ]),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Selector<CustomerProvider, int>(
                          selector: (p0, provider) => provider.getOrders.length,
                          builder: (_, selectorValue, __) => Text(
                            'Orders: $selectorValue',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Consumer<CustomerProvider>(
                      builder: (context, providerValue, child) => DropdownButton<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        icon: const Icon(Icons.filter_alt),
                        alignment: Alignment.center,
                        iconSize: 30,
                        value: providerValue.getSelectedFilter,
                        items: providerValue.profileFilterList
                            .map((e) => DropdownMenuItem<String>(child: Text(e), value: e))
                            .toList(),
                        onChanged: (value) {
                          print('THIS IS THE VALUE: $value');
                          providerValue.onChangeFilterValue(
                            newValue: value!,
                            customerId: widget.customerId,
                          );
                        },
                      ),
                    ),
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
                        : Consumer<CustomerProvider>(
                            builder: (context, providerValue, child) => ListView.builder(
                              itemCount: providerValue.getOrders.length,
                              itemBuilder: (context, index) {
                                Order targetOrder = providerValue.getOrders[index];
                                String registerStr = customerProvider.betterFormatedDate(targetOrder.registeredDate);
                                String deadlineStr = customerProvider.betterFormatedDate(targetOrder.deadLineDate);

                                return buildDismissible(targetOrder, context, registerStr, deadlineStr);
                                //                     Card(
                                //                 color: customerProvider.deadlineColor(
                                //                     targetOrder,
                                //                     Colors.white70,
                                //                     Colors.red.shade200,
                                //                     Colors.orange.shade200),
                                //                 child: ListTile(
                                //                   tileColor: customerProvider.deadlineColor(
                                //                       targetOrder,
                                //                       AppColorsAndThemes.subPrimaryColor,
                                //                       Colors.red.shade200,
                                //                       Colors.orange.shade200),
                                //                   minVerticalPadding: 0,
                                //                   onTap: () => Navigator.of(context)
                                //                       .pushNamed(RouteManager.orderPage,
                                //                           arguments: {
                                //                         'customerId': widget.customerId,
                                //                         'orderId': targetOrder.id
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDismissible(Order targetOrder, BuildContext context, String registerStr, String deadlineStr) {
    return Selector<CustomerProvider, CustomerProvider>(
      selector: (ctx, provider) => provider,
      builder: (_, providerValue, __) => Dismissible(
          key: Key(targetOrder.id),
          onDismissed: (direction) {
            providerValue.removeOrderFromOrderList(removableOrder: targetOrder, customerId: widget.customerId);
            providerValue.getReportOrders.removeWhere(
              (element) => element.id == targetOrder.id,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                width: MediaQuery.of(context).size.width * 90 / 100,
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () async {
                    providerValue.addOrderToOrderList(targetOrder: targetOrder);
                    providerValue.getReportOrders.add(targetOrder);
                    await Customer.updateOrderList(
                        customer: providerValue.customer(targetOrder.customerId),
                        newOrderList: providerValue.getOrders);
                  },
                ),
                content: const Text(
                  'Order is removed successfully',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            );
          },
          confirmDismiss: (direction) async {
            return await buildShowDialogWhenRemovingOrder(context);
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
          child: buildCardListView(
            order: targetOrder,
            provider: providerValue,
            registerDate: registerStr,
            deadline: deadlineStr,
            // popUp: Icon(Icons.phone_android)
          )),
    );
  }

  /// show a dialog box when removing an existing order
  Future<bool?> buildShowDialogWhenRemovingOrder(BuildContext context) {
    return showDialog(
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// this method shows every single card showing on the profile.
  Widget buildCardListView(
      {required CustomerProvider provider,
      required String registerDate,
      required String deadline,
      required Order order}) {
    return Card(
      elevation: 5,
      shadowColor: AppColorsAndThemes.secondaryColor,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(RouteManager.orderPage, arguments: {'customerId': widget.customerId, 'orderId': order.id});
          provider.checkAndSetOrderDeadline(orderId: order.id, customerId: widget.customerId);
        },
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
  final Order order;
  final CustomerProvider provider;
  final Customer customer;

  const CustomPopupMenuButton({super.key, required this.order, required this.customer, required this.provider});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
            value: 'Sewn NOT Delivered',
            onTap: () => provider.onPopupMenu(order: order, value: 'Sewn NOT Delivered', customer: customer),
            child: _SimpleRowForTextIcon(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                text: 'Sewn NOT Delivered',
                icon: const Icon(Icons.circle, color: AppColorsAndThemes.secondaryColor),
                firstIconThenText: false)),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: 'Sewn & Delivered',
          onTap: () => provider.onPopupMenu(order: order, value: 'Sewn & Delivered', customer: customer),
          child: _SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: 'Sewn & Delivered',
            icon: Icon(
              Icons.circle,
              color: Colors.green[800],
            ),
            firstIconThenText: false,
          ),
        ),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: 'In Progress',
          onTap: () => provider.onPopupMenu(order: order, value: 'In Progress', customer: customer),
          child: _SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: 'In Progress',
            icon: Icon(Icons.circle, color: Colors.orange.shade700),
            firstIconThenText: false,
          ),
        ),
      ],
    );
  }
}

// Simple row to show icon and a text next to each other like. which one usage is inside popup
// menu buttons on Orders
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
Widget _buildPhoneCard({required String phoneNumber}) {
  return Expanded(
    child: Card(
      elevation: 5,
      shadowColor: AppColorsAndThemes.secondaryColor,
      child: ListTile(
        tileColor: AppColorsAndThemes.subPrimaryColor,
        contentPadding: const EdgeInsets.only(left: 3),
        leading: const Icon(
          Icons.phone_android,
          color: Colors.black45,
        ),
        title: Text(
          phoneNumber.length > 2 ? phoneNumber : 'Not Available',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),
        ),
      ),
    ),
  );
}
