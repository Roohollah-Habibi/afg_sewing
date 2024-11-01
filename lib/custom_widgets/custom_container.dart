import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;
  final DecorationImage? backgroundImg;

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final AlignmentGeometry? alignment;
  final Color? color;

  const CustomContainer({
    super.key,
    this.child,
    this.backgroundImg,
    this.borderRadius = 20.0,
    this.boxShadow,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.decoration,
    this.alignment,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: decoration ??
          BoxDecoration(
              color: color ?? Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: AppColorsAndThemes.optional, width: 2),
              boxShadow: boxShadow,
              image: backgroundImg),
      child: child,
    );
  }
}
