import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
part 'order.g.dart';
var _uuid = const Uuid();
@HiveType(typeId: 2)
class Order extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime orderDate;

  @HiveField(2)
  final DateTime deliveryDate;

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

  Order({
    required this.id,
    required this.orderDate,
    required this.deliveryDate,
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

  Order.temp(
      {
        required this.id,
      required this.orderDate,
      required this.deliveryDate,
      this.qad = '',
      this.shana = '',
      this.astinSada = '',
      this.astinKaf = '',
      this.yeqa = '',
      this.beghal = '',
      this.shalwar = '',
      this.parcha = '',
      this.qout = '',
      this.damAstin = '',
      this.barAstin = '',
      this.jibShalwar = '',
      this.qadPuti = '',
      this.barShalwar = '',
      this.faq = '',
      this.doorezano = '',
      this.kaf = '',
      this.jibRoo = '',
      this.damanRast = '',
      this.damanGerd = '',
      this.model = '',
      this.totalCost = 0,
      this.receivedMoney = 0,
      this.remainingMoney = 0});

  @override
  List<Object?> get props => [id,qad];
  @override
  bool? get stringify => true;
}
