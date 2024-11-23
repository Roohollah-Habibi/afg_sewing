import 'package:flutter/material.dart';

/// Simple row to show icon and a text next to each other . one usage is inside popup menu buttons on Orders
class SimpleRowForTextIcon extends StatelessWidget {
   final String text;
   final Icon icon;
   final bool firstIconThenText;
   final MainAxisAlignment mainAxisAlignment;
   final CrossAxisAlignment crossAxisAlignment;
   final MainAxisSize mainAxisSize;

  const SimpleRowForTextIcon(
      {super.key,
        required this.text,
        required this.icon,
        this.firstIconThenText = true,
        this.mainAxisAlignment = MainAxisAlignment.start,
        this.crossAxisAlignment = CrossAxisAlignment.start,
        this.mainAxisSize = MainAxisSize.min});

  @override
  Widget build(BuildContext context) {
    return firstIconThenText
        ? Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        icon,
        const SizedBox(width: 15),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    )
        : Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(text),
        const SizedBox(width: 15),
        icon,
      ],
    );
  }
}