import 'package:afg_sewing/custom_widgets/custom_container.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';

import 'package:flutter/material.dart';

class ScreenItems extends StatelessWidget {
  final String childText;
  final String backgroundImg;
  final void Function() onTap;

  const ScreenItems(
      {super.key,
      required this.childText,
      required this.backgroundImg,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> boxShadow = const [
      BoxShadow(
          color: AppColorsAndThemes.accentColor,
          spreadRadius: 5,
          blurRadius: 30,
          offset: Offset(0, 10))
    ];
    TextStyle? txtTheme = Theme.of(context).textTheme.titleLarge;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomContainer(
            width: MediaQuery.of(context).size.width * 50 / 100,
            height: MediaQuery.of(context).size.height * 30 / 100,
            margin: const EdgeInsets.all(15.0),
            boxShadow: boxShadow,
            backgroundImg: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(backgroundImg),
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width * 50 / 100,
          //   height: MediaQuery.of(context).size.height * 30 / 100,
          //   margin: const EdgeInsets.all(15.0),
          //   padding: const EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadiusDirectional.circular(20),
          //     border: Border.all(color: AppColorsAndThemes.optional, width: 2),
          //     color: Colors.transparent,
          //     boxShadow: boxShadow,
          //     image: DecorationImage(
          //       fit: BoxFit.cover,
          //       image: AssetImage(backgroundImg),
          //     ),
          //   ),
          // ),
          Text(
            childText,
            style: txtTheme,
          )
        ],
      ),
    );
  }
}
