import 'package:afg_sewing/custom_widgets/add_customer_panel.dart';
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String appDb = 'SwingDb';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Customer> _customerList;
  final Box swingBox = Hive.box(appDb);

  Future<void> deleteCustomer(Customer customer) async {
    _customerList.removeWhere(
      (element) => element == customer,
    );
    await swingBox.delete(customer.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _customerList = swingBox.values.cast<Customer>().toList();
  }

  void _addNewProfile(BuildContext context) {
    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 800,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const CustomShowModelSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helloWorld),
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          _addNewProfile(context);
        },
        icon: const Icon(Icons.add),
        label: const Text('New Customer'),
      ),
      body: Center(
        child: _customerList.isEmpty
            ? const Text('No Customer is available')
            : ListView.separated(
                itemBuilder: (context, index) {
                  Customer customer = _customerList[index];
                  final List<Order>? customerOrder =
                      _customerList[index].customerOrder;
                  return Card(
                    child: ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                          RouteManager.customerProfile,
                          arguments: {'id': customer.id}),
                      title: Text(customer.firstName),
                      subtitle:
                          Text('${customerOrder?.length ?? 'No Order yet'}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) async {
                          if (value == 'edit') {
                            // Add your edit action here
                          } else if (value == 'delete') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Icon(
                                  Icons.warning_amber,
                                  size: 40,
                                  color: Colors.yellow,
                                ),
                                content: const Text(
                                  'Customer is about to delete!',
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      if(mounted){
                                        Navigator.of(context).pop();
                                      await deleteCustomer(customer);
                                      }
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
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                      height: 10,
                      color: Colors.orange,
                      thickness: 3,
                      endIndent: 20,
                      indent: 20,
                    ),
                itemCount: _customerList.length),
      ),
    );
  }
}
