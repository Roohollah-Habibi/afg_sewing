import 'package:afg_sewing/constants/constants.dart';
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
          color: AppColorsAndThemes.secondaryColor,
          spreadRadius: 0,
          blurRadius: 12,
          blurStyle: BlurStyle.outer,
          offset: Offset(10, 10))
    ];
    TextStyle? txtTheme = Theme.of(context).textTheme.titleLarge;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomContainer(
            width: MediaQuery.of(context).size.width * 50 / 100,
            height: MediaQuery.of(context).size.height * 30 / 100,
            margin: const EdgeInsets.fromLTRB(10,20,20,20),
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
