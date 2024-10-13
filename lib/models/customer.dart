import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'customer.g.dart';

@HiveType(typeId: 1)
class Customer extends HiveObject with EquatableMixin{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String phoneNumber1;

  @HiveField(4)
  final String? phoneNumber2;

  @HiveField(5)
  final List<Order>? customerOrder;

  @HiveField(6)
  bool? customerStatus;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber1,
    this.phoneNumber2,
    this.customerOrder,
    this.customerStatus = false
  });
  void addNewOrder(Order newOrder){
    customerOrder!.add(newOrder);
    debugPrint('=======> Successfully ADDED <========');
  }
  void removeOrder(Order order){
    customerOrder!.removeWhere((foundOrder) => foundOrder == order,);
    debugPrint('=======> Successfully REMOVED <========');
  }
  void editOrder(Order oldOrder, Order replacedOrder){
    final oldOrderIndex = customerOrder!.indexWhere((element) => element == oldOrder,);
    if(oldOrderIndex < 0){
     debugPrint('=======> OLD ORDER NOT FOUND <========');
     return;
    }
    customerOrder!.removeAt(oldOrderIndex);
    customerOrder!.insert(oldOrderIndex, replacedOrder);
    debugPrint('=======> Successfully Replaced <========');
  }

  @override
  List<Object?> get props => [id,firstName,lastName,phoneNumber1,phoneNumber2];

  @override
  bool? get stringify => true;
}
