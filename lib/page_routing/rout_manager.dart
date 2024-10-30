import 'package:afg_sewing/screens/all_order_screens.dart';
import 'package:afg_sewing/screens/customer_profile.dart';
import 'package:afg_sewing/screens/customer_page.dart';
import 'package:afg_sewing/screens/home_page.dart';
import 'package:afg_sewing/screens/order_page.dart';
import 'package:afg_sewing/screens/reports.dart';
import 'package:afg_sewing/screens/samples/order_full_screen.dart';
import 'package:afg_sewing/screens/samples/sample_page.dart';
import 'package:afg_sewing/screens/samples/yekhan.dart';
import 'package:flutter/material.dart';

class RouteManager {
  static const root = '/';
  static const allOrdersScreen = '/allOrdersScreen';
  static const customers = '/customers';
  static const samples = '/samplePage';
  static const yekhan = '/yekhan';
  static const fullOrderScreen = '/fullOrderScreen';
  static const customerProfile = '/customerProfile';
  static const orderPage = '/orderPage';
  static const reports = '/reportPage';

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
        break;
      case yekhan:
        return MaterialPageRoute(
          builder: (context) => const Yekhan(),
        );
            break;
      case allOrdersScreen:
        return MaterialPageRoute(
          builder: (context) => const AllOrderScreens(),
        );
        break;
        case fullOrderScreen:
        return MaterialPageRoute(
          builder: (context) => OrderFullScreen(pageIndex: arguments['pageIndex']),
        );
        break;
      case samples:
        return MaterialPageRoute(
          builder: (context) => const SamplePage(),
        );
        break;
      case customers:
        return MaterialPageRoute(builder: (context) => const Customers());
        break;
      case customerProfile:
        return MaterialPageRoute(
            builder: (context) => CustomerProfile(customerId: arguments['id']));
        break;
      case orderPage:
        return MaterialPageRoute(
          builder: (context) => OrderPage(
            customerId: arguments['customerId'],
            orderId: arguments['orderId'],
          ),
        );
        break;
      case reports:
        return MaterialPageRoute(builder: (context) => const Reports(),);
        break;
      default:
        throw const FormatException(
            'RoutManager ============ Page not found ===========');
    }
  }
}
