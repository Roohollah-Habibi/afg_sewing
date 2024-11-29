
import 'package:afg_sewing/custom_widgets/report_tab.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

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
  // DateTime _today = DateTime.now();
  @override
  void initState() {
    super.initState();
    // _today = context.read<CustomerProvider>().formatMyDate(myDate: _today,returnAsDate: true) as DateTime;
    tabController = TabController(length: 4, vsync: this);
    setState(() {
      numberOfAllCustomers = swingBox.values.whereType<Customer>().toList().length;
      allCustomers = swingBox.values.whereType<Customer>().cast<Customer>().toList();
      allOrders = [for (Customer eachCustomer in allCustomers) ...eachCustomer.customerOrder];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reports),
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
                        tabs: [
                          Text(AppLocalizations.of(context)!.week),
                          Text(AppLocalizations.of(context)!.month),
                          Text(AppLocalizations.of(context)!.year),
                          Text(AppLocalizations.of(context)!.custom),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(
                        controller: tabController,
                        children: [
                      const ReportTab(days: 7),
                      const ReportTab(days: 30),
                      const ReportTab(days: 365),
                      Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Center(child: Text('Working on it')),
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
        buildSummaryReport(text: AppLocalizations.of(context)!.customers, content: '$numberOfAllCustomers',),
        buildSummaryReport(text: AppLocalizations.of(context)!.orders, content: '${allOrders.length}'),
        buildSummaryReport(text: AppLocalizations.of(context)!.employees, content: '4'),
        buildSummaryReport(text: AppLocalizations.of(context)!.lastBackup, content: '2024-01-22'),
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
          buildSummaryReport(text: '${AppLocalizations.of(context)!.employees}: ', content: AppLocalizations.of(context)!.comingSoon,
              reportDataColor: reportContentColor, reportTitleColor:
          reportTitleColor),
          buildSummaryReport(text: AppLocalizations.of(context)!.lastBackup, content: AppLocalizations.of(context)!.comingSoon,reportDataColor:
          reportContentColor,reportTitleColor:
          reportTitleColor),
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
