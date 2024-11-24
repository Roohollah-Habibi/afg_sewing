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
        print('##########> ${element.registeredDate}');
        print('###LAST WEEK #######> $lastWeekDateTime');
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
                          Text('Last Week'),
                          Text('Last Month'),
                          Text('Last Year'),
                          Text('Custom'),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(controller: tabController, children: [
                      Consumer<CustomerProvider>(
                        builder: (context, provider, child) {
                          int numberOfLastWeekCustomers = provider.getCustomers.where((foundCustomer) => _today.difference
                            (foundCustomer.registerDate).inDays <= 7).length;
                          print('____NW_____ ${provider.getCustomers.map((foundCustomer) => _today.difference
                            (foundCustomer.registerDate).inDays)} ___________-');
                         print('${provider.getCustomers.map((e) =>  print('++++++> ${e.firstName} == ${e.registerDate}')).toList()}');
                          return buildTabContainer(
                            reportCustomerTxt: 'customers: ',
                            reportOrderTxt: 'orders: ',
                            reportCustomerData: '$numberOfLastWeekCustomers',
                            reportOrderData: '${info['ordersInLastWeek']}',
                          reportTitleColor: AppColorsAndThemes.secondaryColor,
                          reportContentColor: Colors.black
                        );
                        },
                      ),
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
                        child: overallReport(),
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
