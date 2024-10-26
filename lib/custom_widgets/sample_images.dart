import 'package:flutter/material.dart';

class SampleImages extends StatelessWidget {
  final String imgSrc;
  const SampleImages({super.key,required this.imgSrc});

  @override
  Widget build(BuildContext context) {
    return Image.asset(imgSrc,fit: BoxFit.cover,);
  }
}
