import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<BoxShadow> boxShadow = const [
    BoxShadow(color: AppColorsAndThemes.accentColor, spreadRadius: 5)
  ];
  late final CustomerProvider provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<CustomerProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشتری ها'),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          provider.onAddNewCustomerBtn(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Customer'),
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, customerProvider, _) => Center(
          child: customerProvider.getCustomers.isEmpty
              ? Text(
                  'No Customer is available',
                  style: Theme.of(context).textTheme.titleLarge,
                )
              : Consumer<CustomerProvider>(
                  builder: (context, customerProvider, _) {

                    return ListView.separated(
                    itemCount: customerProvider.getCustomers.length,
                    itemBuilder: (context, index) {
                      Customer customer = customerProvider.getCustomers[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              RouteManager.customerProfile,
                              arguments: {'id': customer.id});
                        },
                        title: Text(
                            customerProvider.getCustomers[index].firstName),
                        leading: customer.status
                            ? const Icon(
                                Icons.online_prediction_outlined,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.online_prediction,
                                color: Colors.red,
                              ),
                        subtitle:
                            Text('Orders: ${customer.customerOrder.length}'),
                        trailing: buildPopupMenuButton(
                            customerProvider, context, customer),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  );
                  },
                ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton(
      CustomerProvider customerProvider,
      BuildContext context,
      Customer customer) {
    return PopupMenuButton<String>(
      onSelected: (String value) async {
        if (value == 'edit') {
          customerProvider.onAddNewCustomerBtn(context, customer: customer);
        } else if (value == 'delete') {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title:  const Icon(
                Icons.warning_amber,
                size: 150,
                color: AppColorsAndThemes.secondaryColor,
              ),
              content: const Text(
                'Customer is about to delete!',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async => await customerProvider.deleteCustomer(
                      context: context, customer: customer),
                  child: const Text('OKey'),
                ),
              ],
            ),
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
        ];
      },
    );
  }
}
