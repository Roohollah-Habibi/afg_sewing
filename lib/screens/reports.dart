
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

const String swingDb = 'SwingDb';

enum Members { customers, employees }

enum Orders { sewnAndDelivered, sewnNotDelivered, inProgress }

enum Time { lastWeek, lastMonth, lastYear, custom }

final String lastWeekStr = DateFormat('yyyy-MM-dd')
    .format(DateTime.now().subtract(const Duration(days: 7)));
final DateTime lastWeekDateTime = DateFormat('yyyy-MM-dd').parse(lastWeekStr);

final String lastMonthStr = DateFormat('yyyy-MM-dd')
    .format(DateTime.now().subtract(const Duration(days: 30)));
final DateTime lastMonthDateTime =
    DateFormat('yyyy-MM-dd').parse(lastMonthStr);

final String lastYearStr = DateFormat('yyyy-MM-dd')
    .format(DateTime.now().subtract(const Duration(days: 365)));
final DateTime lastYearDateTime = DateFormat('yyyy-MM-dd').parse(lastYearStr);

final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
final DateTime today = DateFormat('yyyy-MM-dd').parse(todayStr);

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with TickerProviderStateMixin {
  final TextStyle customStyle =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 17);
  final Box swingBox = Hive.box(swingDb);
  late int numberOfAllCustomers;
  late List<Customer> allCustomers;
  late List<Order> allOrders;
  late TabController tabController;
  late Map<String, dynamic> info;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    setState(() {
      numberOfAllCustomers =
          swingBox.values.whereType<Customer>().toList().length;
      allCustomers =
          swingBox.values.whereType<Customer>().cast<Customer>().toList();
      allOrders = [
        for (Customer eachCustomer in allCustomers)
          ...eachCustomer.customerOrder
      ];
      info = getReport();
    });
  }

  Map<String, dynamic> getReport() {
    Map<String, dynamic> infoMap = {};
    //CUSTOMERS
    List lastWeekCustomers = allCustomers
        .where(
          (element) =>
              element.registerDate.isAfter(lastWeekDateTime) &&
              element.registerDate.isBefore(today),
        )
        .toList();
    List lastMonthCustomers = allCustomers
        .where(
          (element) =>
              element.registerDate.isAfter(lastMonthDateTime) &&
              element.registerDate.isBefore(today.add(const Duration(days: 1))),
        )
        .toList();
    List lastYearCustomers = allCustomers
        .where(
          (element) =>
              element.registerDate.isAfter(lastYearDateTime) &&
              element.registerDate.isBefore(today),
        )
        .toList();
    //ORDERS
    List lastWeekOrders = allOrders
        .where(
          (element) {
            print('##########> ${element.registeredDate}');
            print('###LAST WEEK #######> $lastWeekDateTime');
            return element.registeredDate.isAfter(lastWeekDateTime) &&
              element.registeredDate.isBefore(today);
          },
        )
        .toList();
    List lastMonthOrders = allOrders
        .where(
          (element) =>
              element.registeredDate.isAfter(lastMonthDateTime) &&
              element.registeredDate.isBefore(today),
        )
        .toList();
    List lastYearOrders = allOrders
        .where(
          (element) =>
              element.registeredDate.isAfter(lastYearDateTime) &&
              element.registeredDate.isBefore(today),
        )
        .toList();

    infoMap = {
      'customersInLastWeek': lastWeekCustomers.length,
      'customersInLastMonth': lastMonthCustomers.length,
      'customersInLastYear': lastYearCustomers.length,
      'ordersInLastWeek': lastWeekOrders.length,
      'ordersInLastMonth': lastMonthOrders.length,
      'ordersInLastYear': lastYearOrders.length,
    };

    return infoMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  buildSummaryReport(
                      text: 'Number of Customers: ',
                      content: '$numberOfAllCustomers'),
                  buildSummaryReport(
                      text: 'Number of Orders: ',
                      content: '${allOrders.length}'),
                  buildSummaryReport(
                      text: 'Number of Employees: ', content: '4'),
                  buildSummaryReport(
                      text: 'Last Backup: ', content: '2024-01-22'),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: TabBar(
                        controller: tabController,
                        labelStyle: customStyle,
                        unselectedLabelStyle: customStyle,
                        labelPadding: const EdgeInsets.all(5),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: const [
                          Text('Last Week'),
                          Text('Month'),
                          Text('Year'),
                          Text('Custom'),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(controller: tabController, children: [
                      buildTabContainer(
                          reportCustomerTxt: 'Last week customers: ',
                          reportOrderTxt: 'Last week orders: ',
                          reportCustomerData: '${info['customersInLastWeek']}',
                          reportOrderData: '${info['ordersInLastWeek']}'),
                      buildTabContainer(
                          reportCustomerTxt: 'Last month customers',
                          reportOrderTxt: 'Last month orders',
                          reportCustomerData: info['customersInLastMonth'].toString(),
                          reportOrderData: info['ordersInLastMonth'].toString()),
                      buildTabContainer(
                          reportCustomerTxt: 'Last year customers',
                          reportOrderTxt: 'Last year orders',
                          reportCustomerData: info['customersInLastYear'].toString(),
                          reportOrderData: info['ordersInLastYear'].toString()),
                      Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            buildSummaryReport(
                                text: 'Number of Customers: ',
                                content: '$numberOfAllCustomers'),
                            buildSummaryReport(
                                text: 'Number of Orders: ',
                                content: '${allOrders.length}'),
                            buildSummaryReport(
                                text: 'Number of Employees: ', content: '4'),
                            buildSummaryReport(
                                text: 'Last Backup: ', content: '2024-01-22'),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTabContainer({
    required String reportCustomerTxt,
    required String reportOrderTxt,
    required String reportCustomerData,
    required String reportOrderData,
  }) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: Column(
        children: [
          buildSummaryReport(
              text: reportCustomerTxt, content: reportCustomerData),
          buildSummaryReport(text: reportOrderTxt, content: reportOrderData),
          buildSummaryReport(text: 'Number of Employees: ', content: '4'),
          buildSummaryReport(text: 'Last Backup: ', content: '2024-01-22'),
        ],
      ),
    );
  }

  Widget buildSummaryReport(
      {required String text,
      required content,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$content',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ]),
    );
  }
}
