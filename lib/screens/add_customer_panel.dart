
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

const String appDb = 'SwingDb';

class CustomShowModelSheet extends StatefulWidget {
  final Customer? customer;

  const CustomShowModelSheet({super.key, this.customer});

  @override
  State<CustomShowModelSheet> createState() => _CustomShowModelSheetState();
}

class _CustomShowModelSheetState extends State<CustomShowModelSheet> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneOneController;
  late TextEditingController phoneTwoController;
  late bool customerStatus ;

  @override
  void initState() {
    super.initState();
    customerStatus= widget.customer != null ? widget.customer!.status : true;
    nameController = TextEditingController(text: widget.customer?.firstName);
    lastNameController = TextEditingController(text: widget.customer?.lastName);
    phoneOneController =
        TextEditingController(text: widget.customer?.phoneNumber1);
    phoneTwoController =
        TextEditingController(text: widget.customer?.phoneNumber2);
    userStatus = List.of(_status).map(
      (myItem) {
        return DropdownMenuItem(
          value: myItem,
          child: Text(myItem),
        );
      },
    ).toList();
  }

  final List<String> _status = ['Active', 'Inactive'];
  late final List<DropdownMenuItem<String>> userStatus;
  bool? showFirstNameError, showLastNameError, showPhoneError;

  final Box swingDB = Hive.box(appDb);

  Future<void> addNewCustomer(Customer customer) async {
    await swingDB.put(customer.id, customer);
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneOneController.dispose();
    phoneTwoController.dispose();
    super.dispose();
  }

  Future<void> onSave() async {
    String name = nameController.value.text;
    String lastName = lastNameController.value.text;
    String phoneOne = phoneOneController.value.text;
    String phoneTwo = phoneTwoController.value.text;

    bool nameIsEmpty = nameController.text.isEmpty;
    bool lastNameIsEmpty = lastNameController.text.isEmpty;
    bool phoneIsEmpty = phoneOneController.text.isEmpty;
    if (nameIsEmpty) {
      showFirstNameError = true;
    } else {
      showFirstNameError = null;
    }
    if (lastNameIsEmpty) {
      showLastNameError = true;
    } else {
      showLastNameError = null;
    }
    if (phoneIsEmpty) {
      showPhoneError = true;
    } else {
      showPhoneError = null;
    }
    setState(() {});
    if (!nameIsEmpty && !lastNameIsEmpty && !phoneIsEmpty) {
      var uuid = const Uuid();
      Customer newCustomer = Customer(
          id: widget.customer != null ? widget.customer!.id : uuid.v4(),
          firstName: name,
          lastName: lastName,
          phoneNumber1: phoneOne,
          phoneNumber2: phoneTwo,
          customerOrder:
              widget.customer != null ? widget.customer!.customerOrder : [],
          status: customerStatus);
      await addNewCustomer(newCustomer);
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(RouteManager.customers);
      }
    }
  }

  void _onCancel() {
    Navigator.of(context).pushReplacementNamed(RouteManager.customers);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
          left: 20.0,
          right: 20.0,
          top: 20.0,
        ),
        child: SizedBox(
          height: 800,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.customer != null ? 'Edite profile' : 'Profile',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                txtEditingController: nameController,
                label: 'First Name',
                prefixIcon: const Icon(Icons.person),
                showError: showFirstNameError,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                txtEditingController: lastNameController,
                label: 'Last Name',
                prefixIcon: const Icon(Icons.person),
                showError: showLastNameError,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  txtEditingController: phoneOneController,
                  keyboardType: TextInputType.number,
                  showError: showPhoneError,
                  label: 'Phone one',
                  prefixIcon: const Icon(Icons.mobile_screen_share)),
              const SizedBox(height: 10),
              CustomTextField(
                  keyboardType: TextInputType.number,
                  txtEditingController: phoneTwoController,
                  label: 'Phone two[Optional]',
                  prefixIcon: const Icon(Icons.phone_android)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: widget.customer != null
                    ? widget.customer!.status == true
                        ? _status[0]
                        : _status[1]
                    : _status[0],
                decoration: InputDecoration(
                  labelText: 'Status',
                  enabledBorder: enableInputBorder(Colors.purple),
                  focusedBorder: focusInputBorder(Colors.purpleAccent),
                ),
                items: userStatus,
                onChanged: (value) {
                  value == 'Active' ? customerStatus = true :customerStatus = false;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSave,
                child: Text(
                    widget.customer != null ? 'Edit profile' : 'Save profile'),
              ),
              ElevatedButton(
                onPressed: _onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
