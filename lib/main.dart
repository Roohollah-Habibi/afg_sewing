import 'package:afg_sewing/models/customer.dart';
import 'package:afg_sewing/models/order.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/providers/theam/app_colors_themes.dart';
import 'package:afg_sewing/providers/theam/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(CustomerAdapter());
  await Hive.openBox('SwingDb');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeManagerProvider()),
        ChangeNotifierProvider(create: (context) => SampleProvider(),),
      ],
      child: Consumer<ThemeManagerProvider>(
        builder: (context, themeManger, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: myLightTheme,
          darkTheme: myDarkTheme,
          themeMode: themeManger.themeMode,
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('fa'), // Farsi
          ],
          initialRoute: RouteManager.root,
          onGenerateRoute: RouteManager.pageRouting,
        ),
      ),
    );
  }
}
