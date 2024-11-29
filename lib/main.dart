import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/models_and_List/settings.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/providers/setting_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:afg_sewing/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(SettingsAdapter());
  Hive.registerAdapter(AppLanguageAdapter());
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
        ChangeNotifierProvider(create: (context) => SampleProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(create: (context) => SettingProvider()),
      ],

      child: Consumer<SettingProvider>(
        builder: (context, provider, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: myLightTheme,
          darkTheme: myDarkTheme,
          locale: provider.getSettings.appLanguages == AppLanguage.english ? const Locale('en') : provider.getSettings.appLanguages == AppLanguage
              .pashto ? const Locale('ps') : const Locale('fa'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            // GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          supportedLocales: const[
            Locale('en', ''),  // English
            Locale('fa', ''),  // Persian
            Locale('ps', ''),  // Pashto
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            // This function resolves the best locale for the app.
            // It can be customized if needed.
            if (supportedLocales.contains(locale)) {
              return locale;
            }
            return supportedLocales.first; // Default to first supported locale
          },
          initialRoute: RouteManager.root,
          onGenerateRoute: RouteManager.pageRouting,
        ),
      ),
    );
  }
}
