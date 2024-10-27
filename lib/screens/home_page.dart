import 'package:afg_sewing/custom_widgets/custome_container.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.white70,
      body: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
          ),
          children: [
            CustomContainer(
              backgroundImg: sampleImgSrc,
              childText: 'Samples',
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(RouteManager.samples),
            ),
            CustomContainer(
              backgroundImg: customerImgSrc,
              childText: 'Customers',
              onTap: () => Navigator.of(context)
                  .pushNamed(RouteManager.customers),
            ),
            CustomContainer(
              backgroundImg: orderImgSrc,
              childText: 'Orders',
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(RouteManager.allOrdersScreen),
            ),
            CustomContainer(
              backgroundImg: reportsImgSrc,
              childText: 'Reports',
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(RouteManager.reports),
            ),
          ],
        ),
      ),
    );
  }
}
