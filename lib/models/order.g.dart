// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 2;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as String,
      orderDate: fields[1] as DateTime,
      deliveryDate: fields[2] as DateTime,
      idNumber: fields[3] as String,
      qad: fields[4] as String,
      shana: fields[5] as String,
      astinSada: fields[6] as String,
      astinKaf: fields[7] as String,
      yeqa: fields[8] as String,
      beghal: fields[9] as String,
      shalwar: fields[10] as String,
      parcha: fields[11] as String,
      qout: fields[12] as String,
      damAstin: fields[13] as String,
      barAstin: fields[14] as String,
      jibShalwar: fields[15] as String,
      qadPuti: fields[16] as String,
      barShalwar: fields[17] as String,
      faq: fields[18] as String,
      doorezano: fields[19] as String,
      kaf: fields[20] as String,
      jibRoo: fields[21] as String,
      damanRast: fields[22] as String,
      damanGerd: fields[23] as String,
      model: fields[24] as String,
      totalCost: fields[25] as double,
      receivedMoney: fields[26] as double,
      remainingMoney: fields[27] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(28)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderDate)
      ..writeByte(2)
      ..write(obj.deliveryDate)
      ..writeByte(3)
      ..write(obj.idNumber)
      ..writeByte(4)
      ..write(obj.qad)
      ..writeByte(5)
      ..write(obj.shana)
      ..writeByte(6)
      ..write(obj.astinSada)
      ..writeByte(7)
      ..write(obj.astinKaf)
      ..writeByte(8)
      ..write(obj.yeqa)
      ..writeByte(9)
      ..write(obj.beghal)
      ..writeByte(10)
      ..write(obj.shalwar)
      ..writeByte(11)
      ..write(obj.parcha)
      ..writeByte(12)
      ..write(obj.qout)
      ..writeByte(13)
      ..write(obj.damAstin)
      ..writeByte(14)
      ..write(obj.barAstin)
      ..writeByte(15)
      ..write(obj.jibShalwar)
      ..writeByte(16)
      ..write(obj.qadPuti)
      ..writeByte(17)
      ..write(obj.barShalwar)
      ..writeByte(18)
      ..write(obj.faq)
      ..writeByte(19)
      ..write(obj.doorezano)
      ..writeByte(20)
      ..write(obj.kaf)
      ..writeByte(21)
      ..write(obj.jibRoo)
      ..writeByte(22)
      ..write(obj.damanRast)
      ..writeByte(23)
      ..write(obj.damanGerd)
      ..writeByte(24)
      ..write(obj.model)
      ..writeByte(25)
      ..write(obj.totalCost)
      ..writeByte(26)
      ..write(obj.receivedMoney)
      ..writeByte(27)
      ..write(obj.remainingMoney);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
