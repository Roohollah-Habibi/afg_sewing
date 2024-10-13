import 'dart:ffi';

import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:flutter/material.dart';

class CustomShowModelSheet extends StatefulWidget {
  const CustomShowModelSheet({super.key});

  @override
  State<CustomShowModelSheet> createState() => _CustomShowModelSheetState();
}

class _CustomShowModelSheetState extends State<CustomShowModelSheet> {
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneOneController = TextEditingController();
  final phoneTwoController = TextEditingController();
  final List<String> _status = ['Active', 'Inactive'];
  late final List<DropdownMenuItem<String>> userStatus;
  bool? showFirstNameError, showLastNameError, showPhoneError;

  void onSave() {
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
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    userStatus = List.of(_status)
        .map((myItem) => DropdownMenuItem(
              value: myItem,
              child: Text(myItem),
            ))
        .toList();
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
              const Text(
                'Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
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
                  showError: showPhoneError,
                  keyboardType: TextInputType.number,
                  txtEditingController: phoneTwoController,
                  label: 'Phone two[Optional]',
                  prefixIcon: const Icon(Icons.phone_android)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status[0],
                decoration: InputDecoration(
                  labelText: 'Status',
                  enabledBorder: enableInputBorder(Colors.purple),
                  focusedBorder: focusInputBorder(Colors.purpleAccent),
                ),
                items: userStatus,
                onChanged: (value) {
                  (_status[0] == value)
                      ? _status[1] = value!
                      : _status[0] == value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onSave,
                child: const Text('Save profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
