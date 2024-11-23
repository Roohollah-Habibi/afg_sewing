import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const String appDb = 'SwingDb';

class CustomShowModelSheet extends StatefulWidget {
  final Customer? customer;

  const CustomShowModelSheet({super.key, this.customer});

  @override
  State<CustomShowModelSheet> createState() => _CustomShowModelSheetState();
}

class _CustomShowModelSheetState extends State<CustomShowModelSheet> {
  final Box swingDB = Hive.box(appDb);
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneOneController;
  late TextEditingController phoneTwoController;

  final List<String> _status = ['Active', 'Inactive'];
  late final List<DropdownMenuItem<String>> userStatus;
  final String _todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late final DateTime _today;

  DateTime? providerShowDateTime(BuildContext context) =>
      context.watch<CustomerProvider>().showRegisterDate;

  void _onSave(CustomerProvider provider) {
    String name = nameController.text;
    String last = lastNameController.text;
    String phone = phoneOneController.text;
    String phone2 = phoneTwoController.text;
    provider.onSaveCustomer(
        context: context,
        customer: widget.customer,
        name: name,
        lastName: last,
        phoneOne: phone,
        phoneTwo: phone2);
  }

  @override
  void initState() {
    super.initState();
    _today = DateFormat('yyyy-MM-dd').parse(_todayStr);
    nameController = TextEditingController(text: widget.customer?.firstName);
    lastNameController = TextEditingController(text: widget.customer?.lastName);
    phoneOneController = TextEditingController(
        text: widget.customer != null
            ? widget.customer?.phoneNumber1.substring(2)
            : widget.customer?.phoneNumber1);
    phoneTwoController = TextEditingController(
        text: widget.customer != null
            ? widget.customer?.phoneNumber2.substring(2)
            : widget.customer?.phoneNumber2);
    userStatus = List.of(_status).map(
      (myItem) {
        return DropdownMenuItem(
          value: myItem,
          child: Text(myItem),
        );
      },
    ).toList();
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneOneController.dispose();
    phoneTwoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Text(
              widget.customer != null ? 'Edite profile' : 'Profile',
              style: Theme.of(context)
                  .textTheme
                  .copyWith(
                      displayLarge: const TextStyle(
                          color: AppColorsAndThemes.secondaryColor,
                          fontSize: 35,
                          fontWeight: FontWeight.bold))
                  .displayLarge,
            ),
            const SizedBox(height: 17),
            Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    context
                        .read<CustomerProvider>()
                        .selectRegisterDate(context: context);
                  },
                  label: Text(context
                              .watch<CustomerProvider>()
                              .showRegisterDate !=
                          null
                      ? '${providerShowDateTime(context)?.year}-${providerShowDateTime(context)?.month}-${providerShowDateTime(context)?.day} '
                      : '${_today.year}-${_today.month}-${_today.day}'),
                  icon: const Icon(Icons.date_range),
                  style: Theme.of(context).textButtonTheme.style,
                )),
            CustomTextField(

              fieldKey: CustomerProvider.fieldKeyForName,
              txtEditingController: nameController,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              label: 'First Name',
              prefixIcon: const Icon(Icons.person),
            ),
            CustomTextField(
              fieldKey: CustomerProvider.fieldKeyForLast,
              txtEditingController: lastNameController,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              label: 'Last Name',
              prefixIcon: const Icon(Icons.person),
            ),
            CustomTextField(
                fieldKey: CustomerProvider.fieldKeyForPhone,
                txtEditingController: phoneOneController,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                keyboardType: TextInputType.number,
                maxLength: 8,
                prefixText: '07',
                label: 'Phone one',
                prefixIcon: const Icon(Icons.mobile_screen_share)),
            CustomTextField(
                txtEditingController: phoneTwoController,
                fieldKey: 'phone2',
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                maxLength: 8,
                prefixText: '07',
                keyboardType: TextInputType.number,
                label: 'Phone two[Optional]',
                prefixIcon: const Icon(Icons.phone_android)),
            Consumer<CustomerProvider>(
              builder: (context, customerProvider, _) =>
                  DropdownButtonFormField<String>(
                value: widget.customer != null
                    ? widget.customer!.status == true
                        ? _status[0]
                        : _status[1]
                    : _status[1],
                decoration: InputDecoration(
                  labelText: 'Status',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: AppColorsAndThemes.accentColor, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: AppColorsAndThemes.darkSecondaryColor,
                          width: 3.0)),
                ),
                items: userStatus,
                onChanged: (value) {
                  value == 'Active'
                      ? customerProvider.changeCustomerStatus(true)
                      : customerProvider.changeCustomerStatus(false);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) => ElevatedButton(
                  onPressed: () => _onSave(customerProvider),
                  child: Text(widget.customer != null
                      ? 'Edit profile'
                      : 'Save profile'),
                ),
              ),
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) => ElevatedButton(
                  onPressed: () => customerProvider.onCancel(context),
                  child: const Text('Cancel'),
                ),
              ),
            ]),
            // const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
