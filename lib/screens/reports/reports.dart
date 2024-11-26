import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const String swingDb = 'SwingDb';

enum Members { customers, employees }

enum Orders { sewnAndDelivered, sewnNotDelivered, inProgress }

enum Time { lastWeek, lastMonth, lastYear, custom }

final String lastWeekStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 7)));
final DateTime lastWeekDateTime = DateFormat('yyyy-MM-dd').parse(lastWeekStr);

final String lastMonthStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 30)));
final DateTime lastMonthDateTime = DateFormat('yyyy-MM-dd').parse(lastMonthStr);

final String lastYearStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 365)));
final DateTime lastYearDateTime = DateFormat('yyyy-MM-dd').parse(lastYearStr);

final String todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
final DateTime today = DateFormat('yyyy-MM-dd').parse(todayStr);

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with TickerProviderStateMixin {
  final TextStyle customStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: AppColorsAndThemes.secondaryColor);
  final Box swingBox = Hive.box(swingDb);
  late int numberOfAllCustomers;
  late List<Customer> allCustomers;
  late List<Order> allOrders;
  late TabController tabController;
  late Map<String, dynamic> info;
  DateTime _today = DateTime.now();
  @override
  void initState() {
    super.initState();
    _today = context.read<CustomerProvider>().formatMyDate(myDate: _today,returnAsDate: true) as DateTime;
    tabController = TabController(length: 4, vsync: this);
    setState(() {
      numberOfAllCustomers = swingBox.values.whereType<Customer>().toList().length;
      allCustomers = swingBox.values.whereType<Customer>().cast<Customer>().toList();
      allOrders = [for (Customer eachCustomer in allCustomers) ...eachCustomer.customerOrder];
      info = getReport();
    });
  }

  Map<String, dynamic> getReport() {
    Map<String, dynamic> infoMap = {};
    //CUSTOMERS
    List lastWeekCustomers = allCustomers
        .where(
          (element) => element.registerDate.isAfter(lastWeekDateTime) && element.registerDate.isBefore(_today),
        )
        .toList();
    List lastMonthCustomers = allCustomers
        .where(
          (element) => element.registerDate.isAfter(lastMonthDateTime) && element.registerDate.isBefore(_today.add(const Duration(days: 1))),
        )
        .toList();
    List lastYearCustomers = allCustomers
        .where(
          (element) => element.registerDate.isAfter(lastYearDateTime) && element.registerDate.isBefore(_today),
        )
        .toList();
    //ORDERS
    List lastWeekOrders = allOrders.where(
      (element) {
        return element.registeredDate.isAfter(lastWeekDateTime) && element.registeredDate.isBefore(_today);
      },
    ).toList();
    List lastMonthOrders = allOrders
        .where(
          (element) => element.registeredDate.isAfter(lastMonthDateTime) && element.registeredDate.isBefore(_today),
        )
        .toList();
    List lastYearOrders = allOrders
        .where(
          (element) => element.registeredDate.isAfter(lastYearDateTime) && element.registeredDate.isBefore(_today),
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
        title: const Text('گزارشات'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              elevation: 20,
              shadowColor: AppColorsAndThemes.secondaryColor,
              color: AppColorsAndThemes.secondaryColor,
              margin: const EdgeInsets.all(10),
              child: overallReport(),
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
                          Text('Week'),
                          Text('Month'),
                          Text('Year'),
                          Text('Custom'),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(
                        controller: tabController,
                        children: [
                      Consumer<CustomerProvider>(
                        builder: (context, provider, child) {
                          List<Customer> getCustomers = provider.getCustomers.where((foundCustomer) => _today.difference
                            (foundCustomer.registerDate).inDays <= 7).toList();
                          int numberOfLastWeekCustomers = getCustomers.length;
                          List<Order> getOrders = getCustomers.expand((element) => element.customerOrder).toList();
                          int numberOfLastWeekOrders = getOrders.where((foundOrder) => _today.difference
                            (foundOrder.registeredDate).inDays <= 7).toList().length;
                          return buildTabContainer(
                            reportCustomerTxt: 'Customers: ',
                            reportOrderTxt: 'Orders: ',
                            reportCustomerData: '$numberOfLastWeekCustomers',
                            reportOrderData: '$numberOfLastWeekOrders',
                          reportTitleColor: AppColorsAndThemes.secondaryColor,
                          reportContentColor: Colors.black
                        );
                        },
                      ),
                      Consumer<CustomerProvider>(
                        builder: (context, provider, child) {
                          List<Customer> getCustomers = provider.getCustomers.where((foundCustomer) => _today.difference
                            (foundCustomer.registerDate).inDays <= 30).toList();
                          int numberOfLastMonthCustomers = getCustomers.length;
                          List<Order> getOrders = getCustomers.expand((element) => element.customerOrder).toList();
                          int numberOfLastMonthOrders = getOrders.where((foundOrder) => _today.difference
                            (foundOrder.registeredDate).inDays <= 30).toList().length;
                          return buildTabContainer(
                            reportCustomerTxt: 'Customers',
                            reportOrderTxt: 'Orders',
                            reportCustomerData: '$numberOfLastMonthCustomers',
                            reportOrderData: '$numberOfLastMonthOrders',
                              reportTitleColor: AppColorsAndThemes.secondaryColor,
                              reportContentColor: Colors.black,
                          );
                        },
                      ),
                      Consumer<CustomerProvider>(
                        builder:(_,provider,__) {
                          List<Customer> getCustomers = provider.getCustomers.where((foundCustomer) => _today.difference
                            (foundCustomer.registerDate).inDays <= 365).toList();
                          int numberOfLastYearCustomers = getCustomers.length;
                          List<Order> getOrders = getCustomers.expand((element) => element.customerOrder).toList();
                          int numberOfLastMonthOrders = getOrders.where((foundOrder) => _today.difference
                            (foundOrder.registeredDate).inDays <= 365).toList().length;
                          return buildTabContainer(
                            reportCustomerTxt: 'Customers',
                            reportOrderTxt: 'Orders',
                            reportCustomerData: '$numberOfLastYearCustomers',
                            reportOrderData: '$numberOfLastMonthOrders',
                              reportTitleColor: AppColorsAndThemes.secondaryColor,
                              reportContentColor: Colors.black
                          );
                        },
                      ),
                      Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: Center(child: Text('Worling on it')),
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

  Column overallReport() {
    return Column(
      children: [
        buildSummaryReport(text: 'Number of Customers: ', content: '$numberOfAllCustomers',),
        buildSummaryReport(text: 'Number of Orders: ', content: '${allOrders.length}'),
        buildSummaryReport(text: 'Number of Employees: ', content: '4'),
        buildSummaryReport(text: 'Last Backup: ', content: '2024-01-22'),
      ],
    );
  }

  Container buildTabContainer({
    required String reportCustomerTxt,
    required String reportOrderTxt,
    required String reportCustomerData,
    required String reportOrderData,
    Color? reportTitleColor,
    Color? reportContentColor,
  }) {
    return Container(
      color: Colors.black12,
      alignment: Alignment.center,
      child: Column(
        children: [
          buildSummaryReport(text: reportCustomerTxt, content: reportCustomerData,reportDataColor: reportContentColor,reportTitleColor: reportTitleColor),
          buildSummaryReport(text: reportOrderTxt, content: reportOrderData,reportDataColor: reportContentColor,reportTitleColor: reportTitleColor),
          buildSummaryReport(text: 'Number of Employees: ', content: 'Coming soon',reportDataColor: reportContentColor,reportTitleColor:
          reportTitleColor),
          buildSummaryReport(text: 'Last Backup: ', content: 'Coming soon',reportDataColor: reportContentColor,reportTitleColor: reportTitleColor),
        ],
      ),
    );
  }

  Widget buildSummaryReport({required String text, required content,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween, Color? reportTitleColor = AppColorsAndThemes.subPrimaryColor,
    Color? reportDataColor = AppColorsAndThemes.optional2}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900,color: reportTitleColor),
        ),
        Text(
          '$content',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: reportDataColor),
        ),
      ]),
    );
  }
}
