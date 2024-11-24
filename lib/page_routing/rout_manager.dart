import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/screens/orders/all_order_screens.dart';
import 'package:afg_sewing/screens/customers/customer_page.dart';
import 'package:afg_sewing/screens/customers/customer_profile.dart';
import 'package:afg_sewing/screens/home_page.dart';
import 'package:afg_sewing/screens/orders/order_page.dart';
import 'package:afg_sewing/screens/reports/reports.dart';
import 'package:afg_sewing/screens/samples/Astin.dart';
import 'package:afg_sewing/screens/samples/sample_full_screen.dart';
import 'package:afg_sewing/screens/samples/sample_page.dart';
import 'package:afg_sewing/screens/samples/yekhan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteManager {
  static const root = '/';
  static const allOrdersScreen = '/allOrdersScreen';
  static const customers = '/customers';
  static const samples = '/samplePage';
  static const yekhan = '/yekhan';
  static const astin = '/astin';
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
        return MaterialPageRoute(builder: (context) => const HomePage());
      case yekhan:
        return MaterialPageRoute(builder: (context) => const Yekhan());
        case astin:
        return MaterialPageRoute(builder: (context) => const Astin());
      case allOrdersScreen:
        return MaterialPageRoute(builder: (context) => const AllOrderScreens());
      case fullOrderScreen:
        return MaterialPageRoute(
            builder: (context) =>
                SamplesFullScreen(pageIndex: arguments['pageIndex'],imgSrc: arguments[''],));

      case samples:
        return MaterialPageRoute(builder: (context) => const SamplePage());

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

      case reports:
        return MaterialPageRoute(
          builder: (context) => const Reports(),
        );
      default:
        throw const FormatException(
            'RoutManager ============ Page not found ===========');
    }
  }
}
