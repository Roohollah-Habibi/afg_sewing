import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController txtEditingController;
  final String label;
  final Icon? prefixIcon;
  final TextInputType keyboardType;
  final InputDecoration? customInputDecoration;
  final EdgeInsets? padding;
  final String fieldKey;
  final int? maxLength;
  final String? prefixText;

  const CustomTextField({
    super.key,
    this.prefixText,
    this.padding,
    this.maxLength,
    this.keyboardType = TextInputType.name,
    this.customInputDecoration,
    this.prefixIcon,
    required this.fieldKey,
    required this.txtEditingController,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, customerProvider, _) =>  Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: TextField(
          maxLength: maxLength,
          controller: txtEditingController,
          onChanged: (value) {
            customerProvider.validate(fieldKey,value);
          },
          keyboardType: keyboardType,
          decoration: customInputDecoration?.copyWith(
            labelText: label,
            enabledBorder: enableBorder,
            focusedBorder: focusBorder,
            errorBorder:errorBorder,
            focusedErrorBorder: errorBorder,
          )??
            inputDecoration(
              labelText: label,
              prefixIcon: prefixIcon,
          prefixText: prefixText,
          fieldError: customerProvider.getError(fieldKey)),
        ),
      ),
    );
  }
}

InputDecoration inputDecoration({
  Icon? prefixIcon,
  required String labelText,
  required bool fieldError,
  Color? enableBorderColor,
  Color? focusBorderColor,
  String? prefixText,
}) {
  return InputDecoration(
    prefixText: prefixText,
    prefixStyle: const TextStyle(color: Colors.black,fontSize: 16),
    labelStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.only(left: 40,top: 50),
    prefixIcon: prefixIcon,
    labelText: labelText,
    errorText: fieldError ?'Empty or invalid input' : null,
    enabledBorder: enableBorder,
    focusedBorder: focusBorder,
    errorBorder:errorBorder,
    focusedErrorBorder: errorBorder,
  );
}

OutlineInputBorder get errorBorder => OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: const BorderSide(color: Colors.red,width: 3.0));

OutlineInputBorder get focusBorder => OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: const BorderSide(color: AppColorsAndThemes.darkSecondaryColor,width: 3.0));

OutlineInputBorder get enableBorder => OutlineInputBorder(borderRadius: BorderRadius.circular(10.0),borderSide: const BorderSide(color: AppColorsAndThemes.accentColor, width: 2.0));
