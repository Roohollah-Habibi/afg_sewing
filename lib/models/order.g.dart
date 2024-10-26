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
      isDone: fields[27] as bool,
      isDelivered: fields[28] as bool,
      customerId: fields[29] as String,
      registeredDate: fields[1] as DateTime,
      deadLineDate: fields[2] as DateTime,
      qad: fields[3] as String,
      shana: fields[4] as String,
      astinSada: fields[5] as String,
      astinKaf: fields[6] as String,
      yeqa: fields[7] as String,
      beghal: fields[8] as String,
      shalwar: fields[9] as String,
      parcha: fields[10] as String,
      qout: fields[11] as String,
      damAstin: fields[12] as String,
      barAstin: fields[13] as String,
      jibShalwar: fields[14] as String,
      qadPuti: fields[15] as String,
      barShalwar: fields[16] as String,
      faq: fields[17] as String,
      doorezano: fields[18] as String,
      kaf: fields[19] as String,
      jibRoo: fields[20] as String,
      damanRast: fields[21] as String,
      damanGerd: fields[22] as String,
      model: fields[23] as String,
      totalCost: fields[24] as int,
      receivedMoney: fields[25] as int,
      remainingMoney: fields[26] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.registeredDate)
      ..writeByte(2)
      ..write(obj.deadLineDate)
      ..writeByte(3)
      ..write(obj.qad)
      ..writeByte(4)
      ..write(obj.shana)
      ..writeByte(5)
      ..write(obj.astinSada)
      ..writeByte(6)
      ..write(obj.astinKaf)
      ..writeByte(7)
      ..write(obj.yeqa)
      ..writeByte(8)
      ..write(obj.beghal)
      ..writeByte(9)
      ..write(obj.shalwar)
      ..writeByte(10)
      ..write(obj.parcha)
      ..writeByte(11)
      ..write(obj.qout)
      ..writeByte(12)
      ..write(obj.damAstin)
      ..writeByte(13)
      ..write(obj.barAstin)
      ..writeByte(14)
      ..write(obj.jibShalwar)
      ..writeByte(15)
      ..write(obj.qadPuti)
      ..writeByte(16)
      ..write(obj.barShalwar)
      ..writeByte(17)
      ..write(obj.faq)
      ..writeByte(18)
      ..write(obj.doorezano)
      ..writeByte(19)
      ..write(obj.kaf)
      ..writeByte(20)
      ..write(obj.jibRoo)
      ..writeByte(21)
      ..write(obj.damanRast)
      ..writeByte(22)
      ..write(obj.damanGerd)
      ..writeByte(23)
      ..write(obj.model)
      ..writeByte(24)
      ..write(obj.totalCost)
      ..writeByte(25)
      ..write(obj.receivedMoney)
      ..writeByte(26)
      ..write(obj.remainingMoney)
      ..writeByte(27)
      ..write(obj.isDone)
      ..writeByte(28)
      ..write(obj.isDelivered)
      ..writeByte(29)
      ..write(obj.customerId);
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
