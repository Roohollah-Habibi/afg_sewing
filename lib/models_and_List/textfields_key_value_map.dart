import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> textFields({required Order targetOrder,required CustomerProvider provider}) {
  print('INSIDE KEYmAP=> $targetOrder');
  print('INSIDE KEYmAP=> ${targetOrder.qad}');
  print('INSIDE KEYmAP=> ${targetOrder.totalCost}');
  print('INSIDE KEYmAP=> ${targetOrder.receivedMoney}');
  return [
  {'fieldKey': 'ghad', 'label': 'قد','controller': TextEditingController(text: targetOrder.qad)},

  {'fieldKey': 'shane', 'label': 'شانه','controller':TextEditingController(text: targetOrder.shana),},

  {'fieldKey': 'astinSade', 'label': 'آستین ساده','controller': TextEditingController(text: targetOrder.astinSada),},

  {'fieldKey': 'astinKaf', 'label': 'آستین کف','controller': TextEditingController(text: targetOrder.astinKaf)},

  {'fieldKey': 'yeghe', 'label': 'یقه','controller': TextEditingController(text: targetOrder.yeqa)},

  {'fieldKey': 'baghal', 'label': 'بغل','controller': TextEditingController(text: targetOrder.beghal)},

  {'fieldKey': 'shalwar', 'label': 'شلوار','controller': TextEditingController(text: targetOrder.shalwar)},

  {'fieldKey': 'parche', 'label': 'پاچه','controller': TextEditingController(text: targetOrder.parcha)},

  {'fieldKey': 'ghot', 'label': 'قوت','controller': TextEditingController(text: targetOrder.qout)},

  {'fieldKey': 'damAstin', 'label': 'دم آستین','controller': TextEditingController(text: targetOrder.damAstin)},

  {'fieldKey': 'barAstin', 'label': 'بر آستین','controller': TextEditingController(text: targetOrder.barAstin)},

  {'fieldKey': 'jibShalwar', 'label': 'جیب شلوار','controller': TextEditingController(text: targetOrder.jibShalwar)},

  {'fieldKey': 'qhadPuti', 'label': 'قد پوتی','controller': TextEditingController(text: targetOrder.qadPuti)},

  {'fieldKey': 'barShalwar', 'label': 'بر شلوار','controller': TextEditingController(text: targetOrder.barShalwar)},

  {'fieldKey': 'fagh', 'label': 'فاق','controller': TextEditingController(text: targetOrder.faq)},

  {'fieldKey': 'doorezano', 'label': 'دور زانو','controller': TextEditingController(text: targetOrder.doorezano)},

  {'fieldKey': 'kaf', 'label': 'کف','controller': TextEditingController(text: targetOrder.kaf)},
  {'fieldKey': 'jibroo', 'label': 'جیب رو','controller': TextEditingController(text: targetOrder.jibRoo)},
  {'fieldKey': 'damanRast', 'label': 'دامن راست','controller': TextEditingController(text: targetOrder.damanRast)},
  {'fieldKey': 'damanGerd', 'label': 'دامن گرد','controller': TextEditingController(text: targetOrder.damanGerd)},
  {'fieldKey': 'model', 'label': 'مدل','controller': TextEditingController(text: targetOrder.model)},
  {'fieldKey': 'total', 'label': 'قیمت','controller': TextEditingController(text: targetOrder.totalCost.toString())},
  {'fieldKey': 'received', 'label': 'رسیده','controller': TextEditingController(text: targetOrder.receivedMoney.toString())},
  {'fieldKey': 'remaining', 'label': 'باقی مانده','controller': TextEditingController(text: provider.getOrderRemainingPrice.toString())},
];
}

