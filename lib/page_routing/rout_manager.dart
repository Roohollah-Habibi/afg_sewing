import 'package:afg_sewing/screens/all_order_screens.dart';
import 'package:afg_sewing/screens/customer_profile.dart';
import 'package:afg_sewing/screens/customer_page.dart';
import 'package:afg_sewing/screens/home_page.dart';
import 'package:afg_sewing/screens/order_page.dart';
import 'package:afg_sewing/screens/sample_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const root = '/';
  static const allOrdersScreen = '/allOrdersScreen';
  static const customers = '/customers';
  static const samples = '/samplePage';
  static const customerProfile = '/customerProfile';
  static const orderPage = '/orderPage';

  // static const homePage = '/home';

  static Route<dynamic> pageRouting(RouteSettings setting) {
    Map<String, dynamic> arguments = {};
    if (setting.arguments != null) {
      arguments = setting.arguments as Map<String, dynamic>;
    }
    switch (setting.name) {
      case root:
        return MaterialPageRoute(
          builder: (context) => const HomePage(),
        );
      case allOrdersScreen:
        return MaterialPageRoute(
          builder: (context) => const AllOrderScreens(),
        );
      case samples:
        return MaterialPageRoute(
          builder: (context) => const SamplePage(),
        );
      case customers:
        return MaterialPageRoute(builder: (context) => const Customers());
      case customerProfile:
        return MaterialPageRoute(
            builder: (context) => CustomerProfile(customerId: arguments['id']));
      case orderPage:
        return MaterialPageRoute(
          builder: (context) => OrderPage(
            customerId: arguments['customerId'],
            orderId: arguments['orderId'],
          ),
        );
      default:
        throw const FormatException(
            'RoutManager ============ Page not found ===========');
    }
  }
}
