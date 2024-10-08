class Customer {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber1;
  final String? phoneNumber2;

  Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber1,
    this.phoneNumber2,
  });
}
