import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:afg_sewing/providers/sample_provider.dart';
import 'package:afg_sewing/providers/theam/app_colors_themes.dart';
import 'package:afg_sewing/screens/samples/order_full_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const imgGallaryItemsSrc = 'assets/images/yekhan/yekhan8.jpg';
const imgNotFoundIndex = 10;

class Yekhan extends StatelessWidget {
  const Yekhan({super.key});

  @override
  Widget build(BuildContext context) {
    late final itemIndex;
    List<CustomContainer> items = List.generate(
      100,
      (index) => CustomContainer(
        height: MediaQuery.of(context).size.width * 25 / 100,
        width: MediaQuery.of(context).size.width * 30 / 100,
        backgroundImg: DecorationImage(
            image: AssetImage(
                'assets/images/yekhan/yekhan${(index > 11) ? 10 : index}.jpg'),
            fit: BoxFit.cover),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !context.watch<SampleProvider>().getFullScreen,
        title: Text('یخن ها',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColorsAndThemes.primaryColor,
                )),
      ),
      body: Center(
        child: Stack(
          children: [
            GridView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(2),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) => GestureDetector(
                child: items[index],
                onTap: () =>
                    context.read<SampleProvider>().setFullScreen(show: true,selectedIndex: index),
              ),
            ),
            if (context.watch<SampleProvider>().getFullScreen)
              Center(
                child: CustomContainer(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 80 / 100,
                  child: OrderFullScreen(pageIndex: context.watch<SampleProvider>().getSelectedOrderIndex),
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
