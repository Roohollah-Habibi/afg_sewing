import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/custom_widgets/popup_menu_button.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllOrderScreens extends StatefulWidget {
  const AllOrderScreens({super.key});

  @override
  State<AllOrderScreens> createState() => _AllOrderScreensState();
}

class _AllOrderScreensState extends State<AllOrderScreens> {
  final ScrollController _scrollController = ScrollController();
//   // late List<Customer> allCustomers;
//   final List<String> selectableOrderStatus = [
//     'In Progress',
//     'Swen NOT Delivered',
//     'Sewn & Delivered',
//   ];
//   final List<String> filterOptions = [
//     'In Progress',
//     'Swen NOT Delivered',
//     'Sewn & Delivered',
//     'expired',
//     '2 days left',
//     'just today',
//     'All'
//   ];
//   String selectedFilter = 'All';
  @override
  void initState() {
    super.initState();
    Provider.of<CustomerProvider>(context, listen: false).onChangeReportFilterValue(context.read<CustomerProvider>().getSelectedReport);
    Provider.of<CustomerProvider>(context, listen: false).setExpanded();
    // _scrollController.addListener(_expansionController.collapse);

    // selectedFilter = swingBox.get('filterValueKey') ?? 'In Progress';
    // filterValues(selectedFilter);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // void changeOrderStatusValues(
  //     {required String value, required Order selectedOrder}){
  //   switch (value) {
  //     case 'Swen NOT Delivered':
  //       selectedOrder.isDone = true;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: selectedOrder.customerId,
  //           replaceOrderId: selectedOrder.id);
  //
  //     case 'Sewn & Delivered':
  //       selectedOrder.isDone = true;
  //       selectedOrder.isDelivered = true;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: selectedOrder.customerId,
  //           replaceOrderId: selectedOrder.id);
  //
  //     case 'In Progress':
  //       selectedOrder.isDone = false;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: selectedOrder.customerId,
  //           replaceOrderId: selectedOrder.id);
  //
  //     default:
  //       selectedOrder.isDone = false;
  //       selectedOrder.isDelivered = false;
  //       Customer.addNewOrder(
  //           newOrder: selectedOrder,
  //           customerId: selectedOrder.customerId,
  //           replaceOrderId: selectedOrder.id);
  //   }
  //   onChangeDropdownFilterValue(selectedFilter);
  // }
  //
  // List<PopupMenuEntry<String>> orderStatusSelection(BuildContext context, Order order) =>
  //     [
  //       PopupMenuItem<String>(
  //           onTap: () {
  //             changeOrderStatusValues(
  //                 value: selectableOrderStatus[1], selectedOrder: order);
  //             setState(() {});
  //           },
  //           value: selectableOrderStatus[1],
  //           child: const Text('Swen NOT Delivered')),
  //       PopupMenuItem<String>(
  //         onTap: () {
  //           changeOrderStatusValues(
  //               value: selectableOrderStatus[2], selectedOrder: order);
  //           setState(() {});
  //         },
  //         value: selectableOrderStatus[2],
  //         child: const Text('Sewn & Delivered'),
  //       ),
  //       PopupMenuItem<String>(
  //         onTap: () {
  //           changeOrderStatusValues(
  //               value: selectableOrderStatus[0], selectedOrder: order);
  //           setState(() {});
  //         },
  //         value: selectableOrderStatus[0],
  //         child: const Text('In Progress'),
  //       ),
  //     ];

  // // SHOW FILTER VALUES FOR DROPDOWN BUTTON
  // void filterValues(String? value) async {
  //   final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  //   final today = DateFormat('yyyy-MM-dd').parse(todayStr);
  //   List<Order> tempOrder = [
  //     for (var order in allCustomers) ...order.customerOrder
  //   ];
  //   switch (value) {
  //     case 'All':
  //       allOrders = tempOrder;
  //       break;
  //     case 'Swen NOT Delivered':
  //       allOrders = tempOrder
  //           .where(
  //             (foundOrder) =>
  //                 foundOrder.isDone == true && foundOrder.isDelivered == false,
  //           )
  //           .toList();
  //       break;
  //     case 'Sewn & Delivered':
  //       allOrders = tempOrder
  //           .where(
  //             (foundOrder) =>
  //                 foundOrder.isDelivered == true && foundOrder.isDone == true,
  //           )
  //           .toList();
  //       break;
  //     case 'In Progress':
  //       allOrders = tempOrder
  //           .where((foundOrder) =>
  //               foundOrder.isDone == false && foundOrder.isDelivered == false)
  //           .toList();
  //       break;
  //     case 'expired':
  //       allOrders = tempOrder.where((foundOrder) {
  //         return foundOrder.registeredDate.isAfter(foundOrder.deadLineDate);
  //       },).toList();
  //       break;
  //       case 'just today':
  //       allOrders = tempOrder.where((foundOrder) => foundOrder.deadLineDate.isAtSameMomentAs(today)).toList();
  //       break;
  //       case '2 days left':
  //       allOrders = tempOrder.where((foundOrder) => foundOrder.deadLineDate.subtract(const Duration(days: 2)).isAtSameMomentAs(today)).toList();
  //       break;
  //
  //
  //   }
  //   setState(() {});
  // }

  // void onChangeDropdownFilterValue(String? newValue) async {
  //   if (newValue != null) {
  //     setState(() {
  //       selectedFilter = newValue;
  //     });
  // await swingBox.put('filterValueKey', newValue);
  // filterValues(newValue);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.allOrders),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Selector<CustomerProvider, int>(
                selector: (_, provider) => provider.getReportOrders.length,
                builder: (_, providerValue, __) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${AppLocalizations.of(context)!.orders}: $providerValue',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Consumer<CustomerProvider>(
                    builder: (context, providerValue, child) => DropdownButton<String>(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      icon: const Icon(Icons.filter_alt),
                      alignment: Alignment.center,
                      iconSize: 30,
                      value: providerValue.getSelectedReport,
                      onChanged: (value) => providerValue.onChangeReportFilterValue(value!),
                      items: providerValue.getProfileFilters.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(providerValue.translateFilter(context, value)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Consumer<CustomerProvider>(
            builder: (context, providerValue, child) => providerValue.getReportOrders.isEmpty
                ?  Expanded(
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.noAvailableOrder,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColorsAndThemes.secondaryColor),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: providerValue.getReportOrders.length,
                      itemBuilder: (context, index) {
                        final Order order = providerValue.getReportOrders[index];
                        Customer myCustomer = context.read<CustomerProvider>().getCustomers.firstWhere((element) => element.id == order.customerId);
                        int differenceDates = (Constants.formatMyDate(myDate: order.deadLineDate) as DateTime)
                            .difference((Constants.formatMyDate(myDate: DateTime.now()) as DateTime))
                            .inDays;
                        bool isTileCollapsed = providerValue.isCollapsed(index);
                        return Card(
                          child: ExpansionTile(
                            backgroundColor: AppColorsAndThemes.secondaryColor,
                            collapsedBackgroundColor: AppColorsAndThemes.optional,
                            collapsedTextColor: AppColorsAndThemes.secondaryColor,
                            textColor: AppColorsAndThemes.primaryColor,
                            collapsedIconColor: AppColorsAndThemes.secondaryColor,
                            iconColor: isTileCollapsed ? AppColorsAndThemes.secondaryColor : AppColorsAndThemes.optional,
                            onExpansionChanged: (value) => providerValue.toggleExpansion(index: index, isExpanded: value),
                            title: InkWell(
                              onTap: () => Navigator.of(context).pushNamed(RouteManager.customerProfile, arguments: {'id': myCustomer.id}),
                              child: Text('${myCustomer.firstName} ${myCustomer.lastName}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                            ),
                            subtitle: Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: isTileCollapsed ? AppColorsAndThemes.secondaryColor : AppColorsAndThemes.optional,
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 10,
                                    )
                                  ],
                                  borderRadius: const BorderRadiusDirectional.all(Radius.circular(20))),
                              // margin: const EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width * 50 / 100,
                              height: MediaQuery.of(context).size.height * 20 / 100,
                              child: Column(
                                children: [
                                  Text('${AppLocalizations.of(context)!.registered} ${Constants.formatMyDate(myDate: order.registeredDate,
                                returnAsDate: false)
                              as String}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: isTileCollapsed ? AppColorsAndThemes.subPrimaryColor : AppColorsAndThemes.secondaryColor)),
                                  const SizedBox(height: 20),
                                  Text('${AppLocalizations.of(context)!.deadline}: ${Constants.formatMyDate(myDate: order.deadLineDate,
                                      returnAsDate: false) as String}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: isTileCollapsed ? AppColorsAndThemes.subPrimaryColor : AppColorsAndThemes.secondaryColor)),
                                  const SizedBox(height: 10),
                                  Flexible(
                                    child: Text(
                                      differenceDates < 0 ? '${AppLocalizations.of(context)!.daysPast} $differenceDates' : '${AppLocalizations.of
                                        (context)!.daysLeft} '
                                          '$differenceDates',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: isTileCollapsed ? AppColorsAndThemes.subPrimaryColor : AppColorsAndThemes.secondaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              Card(child: ListTile(
                                trailing: CustomPopupMenuButton(order: order, customer: myCustomer, provider: providerValue),
                                title: ElevatedButton.icon(
                                  icon: Icon(Icons.circle,color: providerValue.getReportOrderStatusColor[order.id]),
                                  onPressed: () => Navigator.of(context).pushNamed(RouteManager.orderPage, arguments: {
                                    'customerId': myCustomer.id,
                                    'orderId'
                                        '': order.id
                                  }),
                                  label: Text(
                                    '${AppLocalizations.of(context)!.orderId} ${myCustomer.id}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.yellow),
                                  ),
                                  style: ElevatedButton.styleFrom(elevation: 5,shadowColor: AppColorsAndThemes.optional),
                                ),
                              ),),
                              const SizedBox(height: 10),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }

// Widget buildCard(
//   BuildContext context, {
//   required Customer customer,
//   bool expandedStatus = false,
//   required int cardIndex,
//   required Order order,
//   required DateTime registeredDate,
//   required DateTime deadLine,
//   required CustomerProvider provider,
// }) {
//   return ExpansionTile(
//     trailing: CustomPopupMenuButton(order: order, customer: customer, provider: provider),
//     title: Container(
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: const BoxDecoration(
//           color: AppColorsAndThemes.secondaryColor,
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 10,
//             )
//           ],
//           borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
//       // margin: const EdgeInsets.all(16),
//       width: MediaQuery.of(context).size.width * 50 / 100,
//       height: MediaQuery.of(context).size.width * 50 / 100,
//       child: Column(
//         children: [
//           ListTile(
//               title: Text('${customer.firstName} ${customer.lastName}'),
//               onTap: () => Navigator.of(context).pushNamed(RouteManager.customerProfile, arguments: {'id': customer.id}),
//               trailing: ExpandIcon(
//                 onPressed: (value) {
//                   print('=== index: $cardIndex ====== $value ============');
//                   bool newValue = provider.getExpandedStatusListForReports[cardIndex];
//                   print('----------- $newValue --------------');
//                   // provider.toggleExpansion(cardIndex, !newValue);
//                 },
//                 color: Colors.yellow,
//                 expandedColor: Colors.black,
//               )),
//
//           // ElevatedButton(
//           //   style: ElevatedButton.styleFrom(
//           //     shadowColor: AppColorsAndThemes.subPrimaryColor,
//           //   ),
//           //   onPressed: () =>
//           //       Navigator.of(context).pushNamed(RouteManager.customerProfile, arguments: {'id': customerId}),
//           //   child: Text(
//           //     '$customerName $customerLastName',
//           //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
//           //   ),
//           // ),
//
//           if (expandedStatus)
//             SizedBox(
//               height: 50,
//               child: GestureDetector(
//                 onTap: () => Navigator.of(context).pushNamed(RouteManager.orderPage, arguments: {'customerId': customer.id, 'orderId': order.id}),
//                 child: Text(
//                   'Order: ${customer.id}',
//                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColorsAndThemes.optional),
//                 ),
//               ),
//             ),
//           Text('Registered: ${registeredDate.year}/${registeredDate.month}/${registeredDate.day}',
//               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//           Text('DeadLine : ${deadLine.year}/${deadLine.month}/${deadLine.day}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//           Flexible(
//             child: Text(
//               'Days Left: ${deadLine.difference(registeredDate).inDays}',
//               style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
}
