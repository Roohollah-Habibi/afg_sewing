import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      locale: Locale('en'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('fa'), // Farsi
      ],
      initialRoute: RouteManager.homePage,
      onGenerateRoute: RouteManager.pageRouting,
      home: HomePage(),
    );
  }
}
