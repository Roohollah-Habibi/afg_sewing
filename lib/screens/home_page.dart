import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/custom_widgets/screen_items.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const sampleImgSrc = 'assets/images/afg-cloth.jpg';
const customerImgSrc = 'assets/images/customers.jpg';
const orderImgSrc = 'assets/images/orders.jpg';
const reportsImgSrc = 'assets/images/reports.png';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Switch(
            value: context.watch<ThemeManagerProvider>().themeMode ==
                ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeManagerProvider>().switchTheme(value);
            },
          ),
        ],
      ),
      body: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 50 / 100,
            mainAxisExtent: MediaQuery.of(context).size.height * 40 / 100,
          ),
          children: [
            ScreenItems(
              backgroundImg: sampleImgSrc,
              childText: 'Samples',
              onTap: () async {
                 await Navigator.of(context)
                  .pushNamed(RouteManager.samples);
              },
            ),
            ScreenItems(
              backgroundImg: customerImgSrc,
              childText: 'Customers',
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteManager.customers),
            ),
            ScreenItems(
              backgroundImg: orderImgSrc,
              childText: 'Orders',
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteManager.allOrdersScreen),
            ),
            ScreenItems(
              backgroundImg: reportsImgSrc,
              childText: 'Reports',
              onTap: () =>
                  Navigator.of(context).pushNamed(RouteManager.reports),
            ),
          ]),
    );
  }
}
