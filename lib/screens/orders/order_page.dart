import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/models_and_List/textfields_key_value_map.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class OrderPage extends StatefulWidget {
  final String customerId;
  final String orderId;

  const OrderPage({super.key, required this.customerId, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  final Map<String, dynamic> _userData = {};
  List<Map<String, dynamic>> myField = [];
  late Order foundOrder;

  @override
  void initState() {
    super.initState();
    foundOrder =
        Order.fromId(orderId: widget.orderId, customerId: widget.customerId);
    Provider.of<CustomerProvider>(context, listen: false)
        .checkAndSetOrderDeadline(
            orderId: widget.orderId, customerId: widget.customerId);
    final customerProvider =
        Provider.of<CustomerProvider>(context, listen: false);

    customerProvider.setPriceValue(
        price: PriceType.received, value: foundOrder.receivedMoney.toString());
    customerProvider.setPriceValue(
        price: PriceType.total, value: foundOrder.totalCost.toString());
    customerProvider.setPriceValue(
        price: PriceType.remaining,
        value: foundOrder.remainingMoney.toString());
    myField = textFields(targetOrder: foundOrder, provider: customerProvider);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.orderId.isEmpty ? AppLocalizations.of(context)!.orders : AppLocalizations.of(context)!.editOrder),
      ),
      body: Builder(builder: (context) {
        final CustomerProvider customerProvider =
            Provider.of<CustomerProvider>(context);
        return Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0, top: 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    '${customerProvider.customer(widget.customerId).firstName} ${customerProvider.customer(widget.customerId).lastName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                ...myField.map(
                  (textFieldsMap) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 33 / 100,
                      child: CustomTextField(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 1),
                          fieldKey: textFieldsMap['fieldKey'] as String,
                          txtEditingController: textFieldsMap['controller']
                              as TextEditingController,
                          label: textFieldsMap['label'] as String,
                          keyboardType:
                              textFieldsMap['fieldKey'] as String == 'model'
                                  ? TextInputType.text
                                  : TextInputType.number),
                    );
                  },
                ),

                SizedBox(
                  //Pick a register date
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: TextButton.icon(
                    onPressed: () async =>
                        await customerProvider.pickRegisterDate(context),
                    label: Text(Constants.formatMyDate(
                        myDate: customerProvider.getOrderRegister!,
                        returnAsDate: false) as String),
                    icon: const Icon(Icons.date_range),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 2),
                  width: MediaQuery.of(context).size.width * 50 / 100,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: customerProvider.getDeadlineOrderColor,
                        padding: const EdgeInsets.symmetric(horizontal: 10)),
                    onPressed: () async =>
                        await customerProvider.pickDeadline(context),
                    label: Text(customerProvider.getOrderInfo['deadline'] ??
                        AppLocalizations.of(context)!.pickDeadLine),
                    icon: const Icon(Icons.date_range),
                  ),
                ),

                const SizedBox(height: 60),
                ElevatedButton.icon(
                //Save Button
                  onPressed: () {
                    for (var map in myField) {
                      _userData[map['fieldKey']] =
                          (map['controller'] as TextEditingController).text;
                    }
                    _userData['isDone'] = foundOrder.isDone;
                    _userData['isDelivered'] = foundOrder.isDelivered;
                    if (customerProvider.handleErrorWhileSaving(context)) {
                      return;
                    }
                    foundOrder = Order.fromMaps(
                        customerId: widget.customerId,
                        orderId: widget.orderId,
                        orderInfo: _userData,
                        register: customerProvider.getOrderRegister!,
                        deadline: customerProvider.getOrderDeadline!);
                    customerProvider.saveNewOrder(
                        context: context,
                        customerId: widget.customerId,
                        targetOrder: foundOrder);
                  },
                  label: Text(widget.orderId.isEmpty ? AppLocalizations.of(context)!.save : AppLocalizations.of(context)!.edit),
                  icon: const Icon(Icons.save),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    customerProvider.onCancelOrder(
                        context: context, orderId: widget.orderId);
                  },
                  label: Text(AppLocalizations.of(context)!.cancel),
                  icon: const Icon(Icons.cancel_outlined),
                ),
              ],
            ),
          ),
        ));
      }),
    );
  }
}
