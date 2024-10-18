import 'package:afg_sewing/screens/customer_profile.dart';
import 'package:afg_sewing/screens/home_page.dart';
import 'package:afg_sewing/screens/order_page.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const root = '/';
  static const customerProfile = '/customerProfile';
  static const orderPage  = '/orderPage';

  // static const homePage = '/home';


  static Route<dynamic> pageRouting(RouteSettings setting) {
    Map<String, dynamic> arguments = {};
    if (setting.arguments != null) {
      arguments = setting.arguments as Map<String, dynamic>;
    }
    switch (setting.name) {
      case root:
        return MaterialPageRoute(builder: (context) => const HomePage(),);
        // return MaterialPageRoute(builder: (context) => const OrderPage(),);
      case customerProfile:
        return MaterialPageRoute(
            builder: (context) => CustomerProfile(customerId: arguments['id']));
      case orderPage:
        return MaterialPageRoute(
            builder: (context) => OrderPage(customerId: arguments['id']));
      default:
        throw const FormatException(
            'RoutManager ============ Page not found ===========');
    }
  }
}