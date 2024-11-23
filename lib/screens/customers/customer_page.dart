import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
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
      body: Center(
          child: Selector<CustomerProvider,List<Customer>>(
            selector: (_, provider) => provider.getCustomers,
            builder:(_,providerVaue,__) => providerVaue.isEmpty ?Text(
                    'No Customer is available',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
              : Consumer<CustomerProvider>(
                  builder: (context, customerProvider, _) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,8,70),
                      child: ListView.separated(
                      itemCount: providerVaue.length,
                      itemBuilder: (context, index) {
                        Customer targetCustomer = providerVaue[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                RouteManager.customerProfile,
                                arguments: {'id': targetCustomer.id});
                          },
                          title: Text(
                              targetCustomer.firstName),
                          leading: targetCustomer.status ?
                               const Icon(Icons.online_prediction_outlined,color: Colors.green)
                              : const Icon(Icons.online_prediction,color: Colors.red),
                          subtitle:
                              Text('Orders: ${targetCustomer.customerOrder.length}'),
                          trailing: buildPopupMenuButton(
                              context.read<CustomerProvider>(), context, targetCustomer),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(color: AppColorsAndThemes.secondaryColor,indent: 10,endIndent: 10,thickness: 1.5,),
                                        ),
                    );
                  },
                ),
        ),
      )
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
                  onPressed: () async {
                    await customerProvider.deleteCustomer(
                      context: context, customer: customer);
                  },
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
