import 'package:afg_sewing/custom_widgets/show_model_sheet.dart';
import 'package:afg_sewing/custom_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _addNewProfile(BuildContext context) {
    showModalBottomSheet(
      scrollControlDisabledMaxHeightRatio: 800,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const CustomShowModelSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.helloWorld),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewProfile(context),
        child: const Icon(Icons.add),
      ),
      body: Center(child: FlutterLogo()),
    );
  }
}
