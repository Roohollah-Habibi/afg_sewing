import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/providers/order_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const swingDb = 'SwingDb';

class OrderPage extends StatefulWidget {
  final String customerId;
  final String orderId;

  const OrderPage({super.key, required this.customerId, required this.orderId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late TextEditingController ghad,
      shane,
      astinSade,
      astinKaf,
      yegha,
      baghal,
      shalwar,
      parche,
      ghot,
      damAstin,
      barAstin,
      jibShalwar,
      ghadPuti,
      barShalwar,
      fagh,
      doorezano,
      kaf,
      jibroo,
      damanRast,
      damanGerd,
      model,
      total,
      received,
      remaining;
  late final List<Map<String, dynamic>> textFields;
   Map<String, String> _userData = {};
  late final Customer customer;

  @override
  void initState() {
    super.initState();
    customer = Provider.of<CustomerProvider>(context,listen: false).customer(widget.customerId);
    Order? foundOrder = widget.orderId.isEmpty
        ? null
        : Provider.of<OrderProvider>(context,listen: false).order(customerId: widget.customerId, orderId: widget.orderId);
    print('--------Order---- ${foundOrder?.id} - قد-- ${foundOrder?.qad}');
    print('-------- CUSTOMER ---- ${customer.id} - =>-- ${customer.customerOrder}');
    ghad = TextEditingController(text: foundOrder?.qad ?? '');
    shane = TextEditingController(text: foundOrder?.shana ?? '');
    astinSade = TextEditingController(text: foundOrder?.astinSada ?? '');
    astinKaf = TextEditingController(text: foundOrder?.astinKaf ?? '');
    yegha = TextEditingController(text: foundOrder?.yeqa ?? '');
    baghal = TextEditingController(text: foundOrder?.beghal ?? '');
    shalwar = TextEditingController(text: foundOrder?.shalwar ?? '');
    parche = TextEditingController(text: foundOrder?.parcha ?? '');
    ghot = TextEditingController(text: foundOrder?.qout ?? '');
    damAstin = TextEditingController(text: foundOrder?.damAstin ?? '');
    barAstin = TextEditingController(text: foundOrder?.barAstin ?? '');
    jibShalwar = TextEditingController(text: foundOrder?.jibShalwar ?? '');
    ghadPuti = TextEditingController(text: foundOrder?.qadPuti ?? '');
    barShalwar = TextEditingController(text: foundOrder?.barShalwar ?? '');
    fagh = TextEditingController(text: foundOrder?.faq ?? '');
    doorezano = TextEditingController(text: foundOrder?.doorezano ?? '');
    kaf = TextEditingController(text: foundOrder?.kaf ?? '');
    jibroo = TextEditingController(text: foundOrder?.jibRoo ?? '');
    damanRast = TextEditingController(text: foundOrder?.damanRast ?? '');
    damanGerd = TextEditingController(text: foundOrder?.damanGerd ?? '');
    model = TextEditingController(text: foundOrder?.model ?? '');
    total = TextEditingController(text: foundOrder?.totalCost.toString() ?? '');
    received =
        TextEditingController(text: foundOrder?.receivedMoney.toString() ?? '');
    remaining = TextEditingController(text: foundOrder?.remainingMoney.toString() ?? '');
    textFields = [
      {'fieldKey': 'ghad', 'controller': ghad, 'label': 'قد'},
      {'fieldKey': 'shane', 'controller': shane, 'label': 'شانه'},
      {
        'fieldKey': 'astinSade',
        'controller': astinSade,
        'label': 'آستین '
            'ساده'
      },
      {'fieldKey': 'astinKaf', 'controller': astinKaf, 'label': 'آستین کف'},
      {'fieldKey': 'yeghe', 'controller': yegha, 'label': 'یقه'},
      {'fieldKey': 'baghal', 'controller': baghal, 'label': 'بغل'},
      {'fieldKey': 'shalwar', 'controller': shalwar, 'label': 'شلوار'},
      {'fieldKey': 'parche', 'controller': parche, 'label': 'پاچه'},
      {'fieldKey': 'ghot', 'controller': ghot, 'label': 'قوت'},
      {'fieldKey': 'damAstin', 'controller': damAstin, 'label': 'دم آستین'},
      {'fieldKey': 'barAstin', 'controller': barAstin, 'label': 'بر آستین'},
      {
        'fieldKey': 'jibShalwar',
        'controller': jibShalwar,
        'label': 'جیب '
            'شلوار'
      },
      {'fieldKey': 'qhadPuti', 'controller': ghadPuti, 'label': 'قد پوتی'},
      {'fieldKey': 'barShalwar', 'controller': barShalwar, 'label': 'بر شلوار'},
      {'fieldKey': 'fagh', 'controller': fagh, 'label': 'فاق'},
      {'fieldKey': 'doorezano', 'controller': doorezano, 'label': 'دور زانو'},
      {'fieldKey': 'kaf', 'controller': kaf, 'label': 'کف'},
      {'fieldKey': 'jibroo', 'controller': jibroo, 'label': 'جیب رو'},
      {'fieldKey': 'damanRast', 'controller': damanRast, 'label': 'دامن راست'},
      {'fieldKey': 'damanGerd', 'controller': damanGerd, 'label': 'دامن گرد'},
      {'fieldKey': 'model', 'controller': model, 'label': 'مدل'},
      {'fieldKey': 'total', 'controller': total, 'label': 'قیمت'},
      {'fieldKey': 'received', 'controller': received, 'label': 'رسیده'},
      // {'fieldKey': 'remaining', 'controller': remaining, 'label': 'باقی مانده'},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Builder(
        builder: (context) {
          final OrderProvider orderProvider = Provider.of<OrderProvider>(context);
          final CustomerProvider customerProvider = Provider.of<CustomerProvider>(context);
          return Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0,top: 10),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                          width: 300,
                          child: Text(
                            '${customer.firstName} ${customer.lastName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                      ...textFields.map(
                        (textFieldsMap) => SizedBox(
                          width: MediaQuery.of(context).size.width * 33 / 100,
                          child: CustomTextField(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 1),
                              fieldKey: textFieldsMap['fieldKey'] as String,
                              txtEditingController:
                                  textFieldsMap['controller'] as TextEditingController,
                              label: textFieldsMap['label'] as String,
                              keyboardType: textFieldsMap['fieldKey'] as String == 'model' ? TextInputType.text: TextInputType.number),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 10 / 100,
                        color: AppColorsAndThemes.subPrimaryColor,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: MediaQuery.of(context).size.width * 33 / 100,
                        child: const Text('test 200'),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 43 / 100,
                        child: Consumer<OrderProvider>(
                          builder: (context, orderProvider, _) => TextButton.icon(
                            onPressed: () => orderProvider.pickRegisterDate(context),
                            label: Text(orderProvider.getRegisterDate),
                            icon: const Icon(Icons.date_range),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 2),
                        width: MediaQuery.of(context).size.width * 54 / 100,
                        child: Consumer<OrderProvider>(
                          builder: (context, orderProvider, _) => ElevatedButton.icon(
                            onPressed: () => orderProvider.pickDeadline(context),
                            label: const Text('pick a deadline'),
                            icon: const Icon(Icons.date_range),
                          ),
                        ),
                      ),

                      const SizedBox(height: 60),
                      //Save Button

                        ElevatedButton.icon(
                          onPressed: () {
                            for(var map  in textFields){
                              _userData[map['fieldKey']] = (map['controller'] as TextEditingController).text;
                            }
                            print('******* $_userData');
                            orderProvider.addNewOrder(
                                context: context,
                                customer: customerProvider.customer(widget.customerId),
                                orderId: widget.orderId,
                                orderInfo: _userData);
                          },
                          label: const Text('Save'),
                          icon: const Icon(Icons.save),
                        ),
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.of(context).pop(RouteManager.orderPage),
                        label: const Text('Cancel'),
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                    ],
                  ),
                ),
              ));
        }
      ),
    );
  }
}
