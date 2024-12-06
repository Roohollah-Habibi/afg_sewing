import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddCustomerPanel extends StatefulWidget {
  final Customer? customer;

  const AddCustomerPanel({super.key, this.customer});

  @override
  State<AddCustomerPanel> createState() => _AddCustomerPanelState();
}

class _AddCustomerPanelState extends State<AddCustomerPanel> {
  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneOneController;
  late TextEditingController phoneTwoController;

  final List<String> _status = ['Active', 'Inactive'];
  late final List<DropdownMenuItem<String>> userStatus;
  final String _todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  late final DateTime _today;

  DateTime? providerShowDateTime(BuildContext context) => context.watch<CustomerProvider>().getCustomerRegisterDate;

  void _onSave(CustomerProvider provider) async{
    String name = nameController.text;
    String last = lastNameController.text;
    String phone = phoneOneController.text;
    String phone2 = phoneTwoController.text;
    await provider.onSaveCustomer(context: context, customer: widget.customer, name: name, lastName: last, phoneOne: phone, phoneTwo: phone2);
  }

  @override
  void initState() {
    super.initState();
    _today = DateFormat('yyyy-MM-dd').parse(_todayStr);
    nameController = TextEditingController(text: widget.customer?.firstName);
    lastNameController = TextEditingController(text: widget.customer?.lastName);
    phoneOneController =
        TextEditingController(text: widget.customer != null ? widget.customer?.phoneNumber1.substring(2) : widget.customer?.phoneNumber1);
    phoneTwoController =
        TextEditingController(text: widget.customer != null ? widget.customer?.phoneNumber2.substring(2) : widget.customer?.phoneNumber2);
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
              widget.customer != null ? AppLocalizations.of(context)!.editProfile: AppLocalizations.of(context)!.profile,
              style: Theme.of(context)
                  .textTheme
                  .copyWith(displayLarge: const TextStyle(color: AppColorsAndThemes.secondaryColor, fontSize: 35, fontWeight: FontWeight.bold))
                  .displayLarge,
            ),
            const SizedBox(height: 17),
            Align(
                alignment: Alignment.centerLeft,
                child: Consumer<CustomerProvider>(
                    builder: (_, providerValue, __) => TextButton.icon(
                    onPressed: () {
                      providerValue.selectRegisterDate(context: context);
                    },
                    label:
                    Text(Constants.formatMyDate(myDate: providerValue.getCustomerRegisterDate, returnAsDate: false) as String),
                    icon: const Icon(Icons.date_range),
                    style: Theme.of(context).textButtonTheme.style,
                  ),
                )),
            CustomTextField(
              fieldKey: Constants.fieldKeyForName,
              txtEditingController: nameController,
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
              label: AppLocalizations.of(context)!.firstName,
              prefixIcon: const Icon(Icons.person),
            ),
            CustomTextField(
              fieldKey: Constants.fieldKeyForLast,
              txtEditingController: lastNameController,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              label: AppLocalizations.of(context)!.lastName,
              prefixIcon: const Icon(Icons.person),
            ),
            CustomTextField(
                fieldKey: Constants.fieldKeyForPhone,
                txtEditingController: phoneOneController,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                keyboardType: TextInputType.number,
                maxLength: 8,
                prefixText: '07',
                label: AppLocalizations.of(context)!.phoneOne,
                prefixIcon: const Icon(Icons.mobile_screen_share)),
            CustomTextField(
                txtEditingController: phoneTwoController,
                fieldKey: 'phone2',
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 5),
                maxLength: 8,
                prefixText: '07',
                keyboardType: TextInputType.number,
                label: AppLocalizations.of(context)!.phoneTwo,
                prefixIcon: const Icon(Icons.phone_android)),
            Consumer<CustomerProvider>(
              builder: (context, customerProvider, _) => DropdownButtonFormField<String>(
                value: widget.customer != null
                    ? widget.customer!.status == true
                        ? _status[0]
                        : _status[1]
                    : _status[1],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.status,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), borderSide: const BorderSide(color: AppColorsAndThemes.accentColor, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: AppColorsAndThemes.darkSecondaryColor, width: 3.0)),
                ),
                items: userStatus,
                onChanged: (value) {
                  value == 'Active' ? customerProvider.changeCustomerStatus(true) : customerProvider.changeCustomerStatus(false);
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) => ElevatedButton(
                  onPressed: () => _onSave(customerProvider),
                  child: Text(widget.customer != null ? AppLocalizations.of(context)!.editProfile : AppLocalizations.of(context)!.profile),
                ),
              ),
              Consumer<CustomerProvider>(
                builder: (context, customerProvider, _) => ElevatedButton(
                  onPressed: () => customerProvider.onCancel(context),
                  child: Text(AppLocalizations.of(context)!.cancel),
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
