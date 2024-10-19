import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'order.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'customer.g.dart';

const String swingDb = 'SwingDb';
var uuid = const Uuid();

@HiveType(typeId: 1)
class Customer extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String phoneNumber1;

  @HiveField(4)
  final String phoneNumber2;

  @HiveField(5)
  final List<Order> customerOrder;

  @HiveField(6)
  final bool status;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber1,
    required this.phoneNumber2,
    required this.customerOrder,
    required this.status,
  });

  static Future <void> addNewOrder(
      {required Order newOrder, required String customerId}) async {
    if (Hive.isBoxOpen(swingDb)) {
      final swingBox = Hive.box(swingDb);
      final Customer customer = swingBox.get(customerId) as Customer;
      customer.customerOrder.add(newOrder);
      await swingBox.put(customerId, customer);
    } else {
      throw const FormatException(
          '====CUSTOMER PAGE======>BOX [$swingDb] IS NOT EXISTS OR OPENED <=========');
    }
  }

  static Future<void> updateOrderList(
      {required Customer customer, required List<Order> newOrderList}) async {
    if (Hive.isBoxOpen(swingDb)) {
      final swingBox = Hive.box(swingDb);
      final updatedCustomer= Customer(id: customer.id,
          firstName: customer.firstName,
          lastName: customer.lastName,
          phoneNumber1: customer.phoneNumber1,
          phoneNumber2: customer.phoneNumber2,
          customerOrder: newOrderList,
          status: customer.status);
      await swingBox.put(customer.id, updatedCustomer);
    }
  }


  @override
  List<Object?> get props =>
      [
        id,
        firstName,
        lastName,
        phoneNumber1,
        phoneNumber2,
        customerOrder,
        status
      ];

  @override
  bool? get stringify => true;
}
