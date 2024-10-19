import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const swingDb = 'SwingDb';

class OrderPage extends StatefulWidget {
  final String customerId;

  const OrderPage({super.key, required this.customerId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController ghad = TextEditingController();
  TextEditingController shane = TextEditingController();
  TextEditingController astinSade = TextEditingController();
  TextEditingController astinKaf = TextEditingController();
  TextEditingController yegha = TextEditingController();
  TextEditingController baghal = TextEditingController();
  TextEditingController shalwar = TextEditingController();
  TextEditingController parche = TextEditingController();
  TextEditingController ghot = TextEditingController();
  TextEditingController damAstin = TextEditingController();
  TextEditingController barAstin = TextEditingController();
  TextEditingController jibShalwar = TextEditingController();
  TextEditingController ghadPuti = TextEditingController();
  TextEditingController barShalwar = TextEditingController();
  TextEditingController fagh = TextEditingController();
  TextEditingController doorezano = TextEditingController();
  TextEditingController kaf = TextEditingController();
  TextEditingController jibroo = TextEditingController();
  TextEditingController damanRast = TextEditingController();
  TextEditingController damanGerd = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController received = TextEditingController();
  TextEditingController remaining = TextEditingController();

  final Box swingBox = Hive.box(swingDb);
  late final Customer customer;

  @override
  void initState() {
    super.initState();
    customer = swingBox.get(widget.customerId);
  }

  Future<void> addNewOrder({required bool saveAndNew}) async {
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
    var uuid = const Uuid();
    final Order newOrder = Order(
      id: uuid.v4(),
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(Duration(days: 3)),
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
        newOrder: newOrder, customerId: widget.customerId);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
              const SizedBox(
                  width: 300,
                  child: Text(
                    'Order Num: 0 ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              const SizedBox(height: 100),

              //Save Button
              ElevatedButton(
                  onPressed: () => addNewOrder(saveAndNew: false),
                  child: const Text('Save')),
              ElevatedButton(
                  onPressed: () => addNewOrder(saveAndNew: true),
                  child: const Text('Save & New')),
              const SizedBox(width: 50),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(RouteManager.customerProfile,arguments: {'id': customer.id});
                  },
                  child: const Text('Cancel')),
            ],
          ),
        ),
      )),
    );
  }
}
