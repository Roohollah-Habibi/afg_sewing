import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  late TextEditingController ghad;

  late TextEditingController shane;

  late TextEditingController astinSade;

  late TextEditingController astinKaf;

  late TextEditingController yegha;

  late TextEditingController baghal;

  late TextEditingController shalwar;

  late TextEditingController parche;

  late TextEditingController ghot;

  late TextEditingController damAstin;

  late TextEditingController barAstin;

  late TextEditingController jibShalwar;

  late TextEditingController ghadPuti;

  late TextEditingController barShalwar;

  late TextEditingController fagh;

  late TextEditingController doorezano;

  late TextEditingController kaf;

  late TextEditingController jibroo;

  late TextEditingController damanRast;

  late TextEditingController damanGerd;

  late TextEditingController model;

  late TextEditingController total;

  late TextEditingController received;

  late TextEditingController remaining;

  bool disableButton = false;

  final Box swingBox = Hive.box(swingDb);
  late final Customer customer;
  DateTime? deadline;

  @override
  void initState() {
    super.initState();
    widget.orderId.isEmpty ? disableButton = false : disableButton = true;
    customer = swingBox.get(widget.customerId);
    Order? foundOrder = widget.orderId.isEmpty
        ? null
        : customer.customerOrder
            .firstWhere((element) => element.id == widget.orderId);
    widget.orderId.isEmpty
        ? deadline = null
        : deadline = foundOrder?.deadLineDate;
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
    remaining = TextEditingController(
        text: foundOrder?.remainingMoney.toString() ?? '');
  }

  Future<void> addNewOrder({required bool saveAndNew}) async {
    var uuid = const Uuid();
    final String userGhad = ghad.value.text;
    final String userShane = shane.value.text;
    final String userAstinSade = astinSade.value.text;
    final String userAstinKaf = astinKaf.value.text;
    final String userYegha = yegha.value.text;
    final String userBaghal = baghal.value.text;
    final String userShalwar = shalwar.value.text;
    final String userParche = parche.value.text;
    final String userGhot = ghot.value.text;
    final String userDamAstin = damAstin.value.text;
    final String userBarAstin = barAstin.value.text;
    final String userJibShalwar = jibShalwar.value.text;
    final String userGhadPuti = ghadPuti.value.text;
    final String userBarShalwar = barShalwar.value.text;
    final String userFagh = fagh.value.text;
    final String userDoorezano = doorezano.value.text;
    final String userKaf = kaf.value.text;
    final String userJibroo = jibroo.value.text;
    final String userDamanRast = damanRast.value.text;
    final String userDamanGerd = damanGerd.value.text;
    final String userModel = model.value.text;
    final int userTotal =
        (total.value.text.isEmpty) ? 0 : int.parse(total.value.text);
    final int userReceived =
        (received.value.text.isEmpty) ? 0 : int.parse(received.value.text);
    final int userRemaining = userTotal - userReceived;
    if (deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 400),
          content: Text('Pick a delivery date'),
        ),
      );
      return;
    }
    final today = DateTime.now();
    final registerDateStr = DateFormat('yyyy-MM-dd').format(today);
    final registerDate = DateFormat('yyyy-MM-dd').parse(registerDateStr);
    final deadLineStr = DateFormat('yyyy-MM-dd').format(deadline!);
    deadline = DateFormat('yyyy-MM-dd').parse(deadLineStr);
    final Order newOrder = Order(
      customerId: customer.id,
      isDone: false,
      isDelivered: false,
      id: widget.orderId.isEmpty ? uuid.v4() : widget.orderId,
      registeredDate: registerDate,
      deadLineDate: deadline!,
      qad: userGhad,
      shana: userShane,
      astinSada: userAstinSade,
      astinKaf: userAstinKaf,
      yeqa: userYegha,
      beghal: userBaghal,
      shalwar: userShalwar,
      parcha: userParche,
      qout: userGhot,
      damAstin: userDamAstin,
      barAstin: userBarAstin,
      jibShalwar: userJibShalwar,
      qadPuti: userGhadPuti,
      barShalwar: userBarShalwar,
      faq: userFagh,
      doorezano: userDoorezano,
      kaf: userKaf,
      jibRoo: userJibroo,
      damanRast: userDamanRast,
      damanGerd: userDamanGerd,
      model: userModel,
      totalCost: userTotal,
      receivedMoney: userReceived,
      remainingMoney: userRemaining,
    );
    await Customer.addNewOrder(
        newOrder: newOrder,
        customerId: widget.customerId,
        replaceOrderId: widget.orderId);
    if (saveAndNew) {
      final controllers = [
        ghad,
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
        remaining
      ];
      for (var controller in controllers) {
        controller.clear();
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(RouteManager.customerProfile,
            arguments: {'id': widget.customerId});
      }
    }
    setState(() {});
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Set the earliest date
      lastDate: DateTime(2100), // Set the latest date
    );

    if (pickedDate != null && pickedDate != deadline) {
      setState(() {
        deadline = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(disableButton ? 'Edit Order' : 'Order'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: Form(
        child: SingleChildScrollView(
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
              SizedBox(
                  width: 300,
                  child: Text(
                    'Order Num: ${disableButton ? customer.customerOrder.indexWhere(
                          (element) => element.id == widget.orderId,
                        ) + 1 : customer.customerOrder.length + 1}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              //todo: this should be better inside a dropdown menu to choose customer

              // HEIGHT
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: ghad,
                  label: 'ghad',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // SHANE
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: shane,
                  label: 'shane',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // ASTIN SADE
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: astinSade,
                  label: 'Astin Sade',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // ASTIN KAF
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: astinKaf,
                  label: 'Astin Kaf',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // yegha
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: yegha,
                  label: 'yeghe',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              //baghal
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: baghal,
                  label: 'baghal',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // shalwar
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: shalwar,
                  label: 'shalwar',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // parche
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: parche,
                  label: 'parche',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // ghot
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: ghot,
                  label: 'ghot',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              //dam astin
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: damAstin,
                  label: 'damAstin',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // bar astin
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: barAstin,
                  label: 'barAstin',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // jibShalwar
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: jibShalwar,
                  label: 'jibShalwar',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // qadPuti
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: ghadPuti,
                  label: 'qadPuti',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // barShalwar
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: barShalwar,
                  label: 'barShalwar',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // faq
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: fagh,
                  label: 'fagh',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // doorezano
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: doorezano,
                  label: 'doorezano',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // kaf
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: kaf,
                  label: 'kaf',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // jibRoo
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: jibroo,
                  label: 'jibRoo',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // damanRast
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: damanRast,
                  label: 'damanRast',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // damanGerd
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: damanGerd,
                  label: 'damanGerd',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // model
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: model,
                  label: 'model',
                  keyboardType: TextInputType.number,
                  customInputDecoration: const InputDecoration(
                    suffixText: 'Cm',
                  ),
                ),
              ),
              // totalCost
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: total,
                  label: 'Total',
                  keyboardType: TextInputType.number,
                  customInputDecoration:
                      const InputDecoration(suffixText: 'AF'),
                ),
              ),
              // received
              SizedBox(
                width: 130,
                child: CustomTextField(
                  txtEditingController: received,
                  label: 'received',
                  keyboardType: TextInputType.number,
                  customInputDecoration:
                      const InputDecoration(suffixText: 'AF'),
                ),
              ),
              // // remaining
              SizedBox(
                width: 130,
                child: CustomTextField(
                  readOnly: true,
                  txtEditingController: remaining,
                  label: 'remaining',
                  keyboardType: TextInputType.number,
                  customInputDecoration:
                      const InputDecoration(suffixText: 'AF'),
                ),
              ),
              SizedBox(
                width: 350,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white54,
                    foregroundColor:
                        deadline != null ? Colors.indigo.shade900 : Colors.red,
                    textStyle: const TextStyle(fontSize: 17)
                  ),
                  onPressed: () => _pickDate(context),
                  label: Text(deadline != null
                      ? 'Deadline: ${deadline!.day}-${deadline!.month}-${deadline!.year}'
                      : 'Deadline: Not set'),
                  icon: const Icon(Icons.date_range),
                ),
              ),
              const SizedBox(height: 70),
              //Save Button
              ElevatedButton.icon(
                onPressed: () => addNewOrder(saveAndNew: false),
                label: Text(disableButton ? 'Save Edit' : 'Save'),
                icon: const Icon(Icons.save),
              ),
              ElevatedButton.icon(
                onPressed:
                    disableButton ? null : () => addNewOrder(saveAndNew: true),
                label: const Text('Save & New'),
                icon: const Icon(Icons.save_alt),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteManager.customerProfile,
                      arguments: {'id': customer.id});
                },
                label: const Text('Cancel'),
                icon: const Icon(Icons.cancel_outlined),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
