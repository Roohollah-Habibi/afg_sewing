import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final DateTime _today = DateTime.now();
 TextStyle _reportTitleStyle = const TextStyle(color: AppColorsAndThemes.secondaryColor,fontSize: 18,fontWeight: FontWeight.w900);
class ReportTab extends StatelessWidget {
  final int days;

  const ReportTab({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (_, provider, __) {
        final reportData = provider.reportInfoBaseDate(day: days);
        int customersInDays = reportData['customers'] as int;
        int ordersInDays = reportData['orders'] as int;
        // List<Customer> getCustomers =
        //     provider.getCustomers.where((foundCustomer) => _today.difference(foundCustomer.registerDate).inDays <= days).toList();
        // int numberOfLastWeekCustomers = getCustomers.length;
        // List<Order> getOrders = getCustomers.expand((element) => element.customerOrder).toList();
        // int numberOfLastWeekOrders = getOrders.where((foundOrder) => _today.difference(foundOrder.registeredDate).inDays <= days).toList().length;
        return buildTabContainer(
            reportCustomerTxt: AppLocalizations.of(context)!.customers,
            reportOrderTxt: AppLocalizations.of(context)!.orders,
            reportCustomerData: '$customersInDays',
            reportOrderData: '$ordersInDays',
            reportTitleColor: AppColorsAndThemes.secondaryColor,
            reportContentColor: Colors.black,
          context: context,
        );
      },
    );
  }
}

Container buildTabContainer({
  required String reportCustomerTxt,
  required String reportOrderTxt,
  required String reportCustomerData,
  required String reportOrderData,
  Color? reportTitleColor,
  Color? reportContentColor,
  required BuildContext context,
}) {
  return Container(
    color: Colors.black12,
    alignment: Alignment.center,
    child: Column(
      children: [
        _buildRowReports(text: reportCustomerTxt, content: reportCustomerData, reportDataColor: reportContentColor, reportTitleColor: reportTitleColor),
        _buildRowReports(text: reportOrderTxt, content: reportOrderData, reportDataColor: reportContentColor, reportTitleColor: reportTitleColor),
        _buildRowReports(text: AppLocalizations.of(context)!.employees, content: 'Coming soon', reportDataColor: reportContentColor, reportTitleColor:
        reportTitleColor),
        _buildRowReports(text: AppLocalizations.of(context)!.lastBackup, content: 'Coming soon', reportDataColor: reportContentColor, reportTitleColor:
        reportTitleColor),
      ],
    ),
  );
}

Widget _buildRowReports(
    {required String text,
    required String content,
    IconData? iconData,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    Color? reportTitleColor = AppColorsAndThemes.subPrimaryColor,
    Color? reportDataColor = AppColorsAndThemes.optional2}) {
  return Padding(
    padding: const EdgeInsets.all(1),
    child: ListTile(
      tileColor: AppColorsAndThemes.primaryColor.withOpacity(.5),
      leading: Icon(iconData ?? Icons.access_alarm,color: Colors.blueGrey,),
      title: Text(text,style: _reportTitleStyle,),
      trailing: Text(content,style: _reportTitleStyle,),
    ),
  );
}

// Building Rows to show reports data in tab views
Widget _buildRowReports2(
    {required String text,
    required content,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.spaceBetween,
    Color? reportTitleColor = AppColorsAndThemes.subPrimaryColor,
    Color? reportDataColor = AppColorsAndThemes.optional2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    child: Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: reportTitleColor),
      ),
      const Expanded(
          child: Divider(
        color: AppColorsAndThemes.secondaryColor,
        thickness: 1,
        endIndent: 20,
        indent: 10,
      )),
      Text(
        '$content',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: reportDataColor),
      ),
    ]),
  );
}
