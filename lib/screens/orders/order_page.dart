import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/models_and_List/textfields_key_value_map.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  final String customerId;
  final String orderId;

  const OrderPage({super.key, required this.customerId, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // late TextEditingController
  // ghad,
  //     shane,
  //     astinSade,
  //     astinKaf,
  //     yegha,
  //     baghal,
  //     shalwar,
  //     parche,
  //     ghot,
  //     damAstin,
  //     barAstin,
  //     jibShalwar,
  //     ghadPuti,
  //     barShalwar,
  //     fagh,
  //     doorezano,
  //     kaf,
  //     jibroo,
  //     damanRast,
  //     damanGerd,
  //     model,
  //     total,
  //     received,
  //     remaining;

  final Map<String, String> _userData = {};
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
    // ghad = TextEditingController(text: foundOrder.qad);
    // shane = TextEditingController(text: foundOrder.shana);
    // astinSade = TextEditingController(text: foundOrder.astinSada);
    // astinKaf = TextEditingController(text: foundOrder.astinKaf);
    // yegha = TextEditingController(text: foundOrder.yeqa);
    // baghal = TextEditingController(text: foundOrder.beghal);
    // shalwar = TextEditingController(text: foundOrder.shalwar);
    // parche = TextEditingController(text: foundOrder.parcha);
    // ghot = TextEditingController(text: foundOrder.qout);
    // damAstin = TextEditingController(text: foundOrder.damAstin);
    // barAstin = TextEditingController(text: foundOrder.barAstin);
    // jibShalwar = TextEditingController(text: foundOrder.jibShalwar);
    // ghadPuti = TextEditingController(text: foundOrder.qadPuti);
    // barShalwar = TextEditingController(text: foundOrder.barShalwar);
    // fagh = TextEditingController(text: foundOrder.faq);
    // doorezano = TextEditingController(text: foundOrder.doorezano);
    // kaf = TextEditingController(text: foundOrder.kaf);
    // jibroo = TextEditingController(text: foundOrder.jibRoo);
    // damanRast = TextEditingController(text: foundOrder.damanRast);
    // damanGerd = TextEditingController(text: foundOrder.damanGerd);
    // model = TextEditingController(text: foundOrder.model);
    // total = TextEditingController(text: foundOrder.totalCost.toString());
    // received = TextEditingController(text: foundOrder.receivedMoney.toString());
    // remaining = TextEditingController(text: customerProvider.getOrderRemainingPrice.toString());

    // _textFields = [
    //   {'fieldKey': 'ghad', 'controller': ghad, 'label': 'قد'},
    //   {'fieldKey': 'shane', 'controller': shane, 'label': 'شانه'},
    //   {
    //     'fieldKey': 'astinSade',
    //     'controller': astinSade,
    //     'label': 'آستین '
    //         'ساده'
    //   },
    //   {'fieldKey': 'astinKaf', 'controller': astinKaf, 'label': 'آستین کف'},
    //   {'fieldKey': 'yeghe', 'controller': yegha, 'label': 'یقه'},
    //   {'fieldKey': 'baghal', 'controller': baghal, 'label': 'بغل'},
    //   {'fieldKey': 'shalwar', 'controller': shalwar, 'label': 'شلوار'},
    //   {'fieldKey': 'parche', 'controller': parche, 'label': 'پاچه'},
    //   {'fieldKey': 'ghot', 'controller': ghot, 'label': 'قوت'},
    //   {'fieldKey': 'damAstin', 'controller': damAstin, 'label': 'دم آستین'},
    //   {'fieldKey': 'barAstin', 'controller': barAstin, 'label': 'بر آستین'},
    //   {
    //     'fieldKey': 'jibShalwar',
    //     'controller': jibShalwar,
    //     'label': 'جیب '
    //         'شلوار'
    //   },
    //   {'fieldKey': 'qhadPuti', 'controller': ghadPuti, 'label': 'قد پوتی'},
    //   {'fieldKey': 'barShalwar', 'controller': barShalwar, 'label': 'بر شلوار'},
    //   {'fieldKey': 'fagh', 'controller': fagh, 'label': 'فاق'},
    //   {'fieldKey': 'doorezano', 'controller': doorezano, 'label': 'دور زانو'},
    //   {'fieldKey': 'kaf', 'controller': kaf, 'label': 'کف'},
    //   {'fieldKey': 'jibroo', 'controller': jibroo, 'label': 'جیب رو'},
    //   {'fieldKey': 'damanRast', 'controller': damanRast, 'label': 'دامن راست'},
    //   {'fieldKey': 'damanGerd', 'controller': damanGerd, 'label': 'دامن گرد'},
    //   {'fieldKey': 'model', 'controller': model, 'label': 'مدل'},
    //   {'fieldKey': 'total', 'controller': total, 'label': 'قیمت'},
    //   {'fieldKey': 'received', 'controller': received, 'label': 'رسیده'},
    //   {'fieldKey': 'remaining', 'controller': remaining, 'label': 'باقی مانده'},
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Order'),
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
                    label: Text(customerProvider.formatMyDate(
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
                        'pick a deadline'),
                    icon: const Icon(Icons.date_range),
                  ),
                ),

                const SizedBox(height: 60),
                //Save Button

                ElevatedButton.icon(
                  onPressed: () {
                    for (var map in myField) {
                      _userData[map['fieldKey']] =
                          (map['controller'] as TextEditingController).text;
                    }
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
                  label: const Text('Save'),
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
                  label: const Text('Cancel'),
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
