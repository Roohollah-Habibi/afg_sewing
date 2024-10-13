import 'package:afg_sewing/custom_widgets/add_customer_panel.dart';
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addNewProfile(context);
        },
        child: const Icon(Icons.add),
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
                        title: Text(customer.firstName),
                        subtitle:
                            Text('${customerOrder?.length ?? 'No Order yet'}'),
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
                  itemCount: _customerList.length)),
    );
  }
}
