import 'package:equatable/equatable.dart';
import 'order.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'customer.g.dart';

const String _swingDb = 'SwingDb';
final Box _swingBox = Hive.box(_swingDb);
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

  @HiveField(7)
  final DateTime registerDate;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber1,
    required this.phoneNumber2,
    required this.customerOrder,
    required this.status,
    required this.registerDate
  });

  /// this method check if any specific order is exist inside customer order replace it otherwise
  /// add it as a new order
  static Future <void> addNewOrder(
      {required Order newOrder, required String customerId,required String replaceOrderId}) async {

      final Customer customer = _swingBox.get(customerId) as Customer;
      if(replaceOrderId.isEmpty){
      customer.customerOrder.add(newOrder);
      }else{
        Order foundOrder= customer.customerOrder.firstWhere((element) => element.id ==
            replaceOrderId);// first we find the order then find the index to replace it
        int orderIndex = customer.customerOrder.indexOf(foundOrder);
        customer.customerOrder.removeAt(orderIndex);
        customer.customerOrder.insert(orderIndex, newOrder);
      }
      await _swingBox.put(customerId, customer);
  }

  /// Usage of this method is for updating customer order list. by new order list
  static Future<void> updateOrderList({required Customer customer, required List<Order> newOrderList}) async {

      final updatedCustomer = Customer(id: customer.id,
          registerDate: customer.registerDate,
          firstName: customer.firstName,
          lastName: customer.lastName,
          phoneNumber1: customer.phoneNumber1,
          phoneNumber2: customer.phoneNumber2,
          customerOrder: newOrderList,
          status: customer.status);
      await _swingBox.put(customer.id, updatedCustomer);

  }

  /// This method is used for removing an order from database of a customer
  static Future<void> removeOrder({required String customerId, required Order removableOrder})async{

      final Customer targetCustomer = _swingBox.get(customerId);
      targetCustomer.customerOrder.removeWhere((element) => element.id == removableOrder.id);
      await _swingBox.put(customerId, targetCustomer);
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
