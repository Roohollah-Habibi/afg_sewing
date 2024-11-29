import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/screens/samples/sample_src.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme txtTheme = Theme.of(context).textTheme.copyWith(
        titleLarge: const TextStyle(
            color: AppColorsAndThemes.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 35));
    List<BoxShadow> boxShadow = const [
      BoxShadow(
          color: AppColorsAndThemes.secondaryColor,
          spreadRadius: 2,
          blurRadius: 6,
          offset: Offset(0, 3))
    ];
    List<CustomContainer> items = List.generate(
      7,
      (index) {
        String? text;
        switch (index) {
          case 0:
            text = 'یخن';
            break;
          case 1:
            text = 'آستین';
            break;
          case 2:
            text = 'پاچه';
            break;
          case 3:
            text = 'شانه';
            break;
          case 4:
            text = 'پشت سر';
            break;
          case 5:
            text = 'جیب رو';
            break;
          case 6:
            text = 'جیب شلوار';
            break;
        }
        return CustomContainer(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 20 / 100,
          margin: const EdgeInsets.all(10),
          boxShadow: boxShadow,
          alignment: Alignment.center,
          child: Text(
            text!,
            style: txtTheme.titleLarge,
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.samples),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _navigateTo(context,index),
              child: items[index],
            );
          },
        ),
      ),
    );
  }
}

void _navigateTo(BuildContext context, int pageIndex) {
  switch (pageIndex) {
    case 0:
      Provider.of<SampleProvider>(context,listen: false).replaceNewImageList(SampleSrc.yekhanSrs);
      Navigator.of(context).pushNamed(RouteManager.yekhan);
      break;
      case 1:
      Provider.of<SampleProvider>(context,listen: false).replaceNewImageList(SampleSrc.astinSrs);
      Navigator.of(context).pushNamed(RouteManager.astin);
      break;
  }
}
