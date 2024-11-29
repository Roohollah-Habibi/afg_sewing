import 'package:afg_sewing/constants/constants.dart';
import 'package:afg_sewing/custom_widgets/screen_items.dart';
import 'package:afg_sewing/models_and_List/settings.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/setting_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:afg_sewing/usecases/setting_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.home), actions: [
        Consumer<SettingProvider>(
          builder: (context, provider, child) => DropdownButton<AppLanguage>(
            dropdownColor: AppColorsAndThemes.secondaryColor,
            value: provider.getSettings.appLanguages,
            items: AppLanguage.values.map((language) {
              return DropdownMenuItem(
                value: language,
                child: Text(
                  language == AppLanguage.english ? 'English' : language == AppLanguage.persian ? 'دری': 'پشتو',
                  style: const TextStyle(color: AppColorsAndThemes.subPrimaryColor, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
            onChanged: (newLanguage) {
              if (newLanguage != null) {
                SettingUseCases(provider).call(newLanguage);
              }
            },
          ),
        ),
      ]),
      body: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.width * 50 / 100,
            mainAxisExtent: MediaQuery.of(context).size.height * 40 / 100,
          ),
          children: [
            ScreenItems(
              backgroundImg: sampleImgSrc,
              childText: AppLocalizations.of(context)!.samples,
              onTap: () async {
                await Navigator.of(context).pushNamed(RouteManager.samples);
              },
            ),
            ScreenItems(
              backgroundImg: customerImgSrc,
              childText: AppLocalizations.of(context)!.customers,
              onTap: () => Navigator.of(context).pushNamed(RouteManager.customers),
            ),
            ScreenItems(
              backgroundImg: orderImgSrc,
              childText: AppLocalizations.of(context)!.orders,
              onTap: () => Navigator.of(context).pushNamed(RouteManager.allOrdersScreen),
            ),
            ScreenItems(
              backgroundImg: reportsImgSrc,
              childText: AppLocalizations.of(context)!.reports,
              onTap: () => Navigator.of(context).pushNamed(RouteManager.reports),
            ),
          ]),
    );
  }
}
