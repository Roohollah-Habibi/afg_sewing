import 'package:afg_sewing/page_routing/rout_manager.dart';
import 'package:flutter/material.dart';



class CustomContainer extends StatelessWidget {
  final String childText;
  final String backgroundImg;
  final void Function() onTap;
  const CustomContainer({super.key,required this.childText,required this.backgroundImg,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(15),
        alignment: const Alignment(0, 1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(backgroundImg),
          ),
        ),
        child: Text(
          childText,
          style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
