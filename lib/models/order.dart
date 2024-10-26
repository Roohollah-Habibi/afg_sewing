import 'package:afg_sewing/models/customer.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'order.g.dart';

@HiveType(typeId: 2)
class Order extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime registeredDate;

  @HiveField(2)
  final DateTime deadLineDate;

  @HiveField(3)
  final String qad;

  @HiveField(4)
  final String shana;

  @HiveField(5)
  final String astinSada;

  @HiveField(6)
  final String astinKaf;

  @HiveField(7)
  final String yeqa;

  @HiveField(8)
  final String beghal;

  @HiveField(9)
  final String shalwar;

  @HiveField(10)
  final String parcha;

  @HiveField(11)
  final String qout;

  @HiveField(12)
  final String damAstin;

  @HiveField(13)
  final String barAstin;

  @HiveField(14)
  final String jibShalwar;

  @HiveField(15)
  final String qadPuti;

  @HiveField(16)
  final String barShalwar;

  @HiveField(17)
  final String faq;

  @HiveField(18)
  final String doorezano;

  @HiveField(19)
  final String kaf;

  @HiveField(20)
  final String jibRoo;

  @HiveField(21)
  final String damanRast;

  @HiveField(22)
  final String damanGerd;

  @HiveField(23)
  final String model;

  @HiveField(24)
  final int totalCost;

  @HiveField(25)
  final int receivedMoney;

  @HiveField(26)
  final int remainingMoney;

  @HiveField(27)
  bool isDone;

  @HiveField(28)
  bool isDelivered;

  @HiveField(29)
  final String customerId;

  Order({
    required this.id,
    this.isDone = false,
    this.isDelivered = false,
    required this.customerId,
    required this.registeredDate,
    required this.deadLineDate,
    required this.qad,
    required this.shana,
    required this.astinSada,
    required this.astinKaf,
    required this.yeqa,
    required this.beghal,
    required this.shalwar,
    required this.parcha,
    required this.qout,
    required this.damAstin,
    required this.barAstin,
    required this.jibShalwar,
    required this.qadPuti,
    required this.barShalwar,
    required this.faq,
    required this.doorezano,
    required this.kaf,
    required this.jibRoo,
    required this.damanRast,
    required this.damanGerd,
    required this.model,
    required this.totalCost,
    required this.receivedMoney,
    required this.remainingMoney,
  });

  factory Order.fromId({required String orderId}){
    late Order foundOrder;
    if (Hive.isBoxOpen(swingDb)) {
      final Box swingBox = Hive.box(swingDb);
      List<Customer> customers = swingBox.values.whereType<Customer>()
          .toList()
          .cast<Customer>();
      List<Order> orderList = [
        for(var order in customers)...order.customerOrder
      ];
      foundOrder = orderList.firstWhere((element) => element.id == orderId,);
    }
    return Order(id: orderId,
        customerId: foundOrder.customerId,
        registeredDate: foundOrder.registeredDate,
        deadLineDate: foundOrder.deadLineDate,
        qad: foundOrder.qad,
        shana: foundOrder.shana,
        astinSada: foundOrder.astinSada,
        astinKaf: foundOrder.astinKaf,
        yeqa: foundOrder.yeqa,
        beghal: foundOrder.beghal,
        shalwar: foundOrder.shalwar,
        parcha: foundOrder.parcha,
        qout: foundOrder.qout,
        damAstin: foundOrder.damAstin,
        barAstin: foundOrder.barAstin,
        jibShalwar: foundOrder.jibShalwar,
        qadPuti: foundOrder.qadPuti,
        barShalwar: foundOrder.barShalwar,
        faq: foundOrder.faq,
        doorezano: foundOrder.doorezano,
        kaf: foundOrder.kaf,
        jibRoo: foundOrder.jibRoo,
        damanRast: foundOrder.damanRast,
        damanGerd: foundOrder.damanGerd,
        model: foundOrder.model,
        totalCost: foundOrder.totalCost,
        receivedMoney: foundOrder.receivedMoney,
        remainingMoney: foundOrder.remainingMoney);
  }

  @override
  List<Object?> get props => [id, qad];

  @override
  bool? get stringify => true;

}
