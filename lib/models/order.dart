class Order {
  final String id;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final String idNumber;
  final String qad;
  final String shana;
  final String astinSada;
  final String astinKaf;
  final String yeqa;
  final String beghal;
  final String shalwar;
  final String parcha;
  final String qout;
  final String damAstin;
  final String barAstin;
  final String jibShalwar;
  final String qadPuti;
  final String barShalwar;
  final String faq;
  final String doorezano;
  final String kaf;
  final String jibRoo;
  final String damanRast;
  final String damanGerd;
  final String model;
  final double totalCost;
  final double receivedMoney;
  final double remainingMoney;

  Order({
    required this.id,
    required this.orderDate,
    required this.deliveryDate,
    required this.idNumber,
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

  Order.temp({required this.id, required this.orderDate, required this.deliveryDate, this.idNumber = '', this.qad = '', this.shana = '', this.astinSada = '', this.astinKaf = '', this.yeqa = '', this.beghal = '', this.shalwar = '', this.parcha = '', this.qout = '', this.damAstin = '', this.barAstin = '', this.jibShalwar = '', this.qadPuti = '', this.barShalwar = '', this.faq = '', this.doorezano = '', this.kaf = '', this.jibRoo = '', this.damanRast = '', this.damanGerd = '', this.model = '', this.totalCost = 0, this.receivedMoney = 0, this.remainingMoney = 0});
}
