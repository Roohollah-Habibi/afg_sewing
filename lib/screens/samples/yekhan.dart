import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:afg_sewing/screens/samples/sample_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Yekhan extends StatelessWidget {
  const Yekhan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            !context.watch<SampleProvider>().getFullScreen,
        title: Text('یخن ها',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColorsAndThemes.primaryColor,
                )),
      ),
      body: Center(
        child: Stack(
          children: [
            GridView.builder(
              itemCount: context.read<SampleProvider>().imgList.length,
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                String imgSrc = 'assets/images/yekhan/yekhan$index.jpg';
                return GestureDetector(
                  child: CustomContainer(
                    margin: const EdgeInsets.all(2),
                    height: MediaQuery.of(context).size.width * 25 / 100,
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(20),
                      image: DecorationImage(
                          image: AssetImage(imgSrc), fit: BoxFit.cover),
                    ),
                  ),
                  onTap: () => context
                      .read<SampleProvider>()
                      .setFullScreen(show: true, selectedIndex: index),
                );
              },
            ),
            if (context.watch<SampleProvider>().getFullScreen)
              Center(
                child: CustomContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 80 / 100,
                  child: Consumer<SampleProvider>(
                    builder: (context, customerProvider, _) =>
                        SamplesFullScreen(
                      pageIndex: customerProvider.getSelectedOrderIndex,
                          imgSrc: customerProvider.imgList,
                    ),
                  ),
                ),
              ),
            if (context.watch<SampleProvider>().getFullScreen)
              Align(
                alignment: const Alignment(.95, -.85),
                child: CloseButton(
                    style: const ButtonStyle(
                      iconSize: WidgetStatePropertyAll(30),
                    ),
                    color: AppColorsAndThemes.secondaryColor,
                    onPressed: () {
                      context.read<SampleProvider>().setFullScreen(show: false);
                    }),
              ),
          ],
        ),
      ),
    );
  }
}
