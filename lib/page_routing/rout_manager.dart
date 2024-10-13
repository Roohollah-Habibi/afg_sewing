
import 'package:afg_sewing/screens/home_page.dart';
import 'package:flutter/material.dart';

class RouteManager{
  static const root = '/';
  static const homePage = '/home';


  static Route pageRouting(RouteSettings setting){
    
    switch(setting.name){
      case homePage:
       return MaterialPageRoute(builder: (context) => const HomePage(),);
      default: throw const FormatException('RoutManager ============ Page not found ===========');
    }
  }
}