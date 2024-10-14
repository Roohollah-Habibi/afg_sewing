import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController txtEditingController;
  final String label;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Icon prefixIcon;
  final TextInputType? keyboardType;
  final bool? showError;


  const CustomTextField({
    super.key,
    this.showError,
    this.keyboardType,
    required this.txtEditingController,
    required this.label,
    required this.prefixIcon,
    this.enabledBorderColor,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all( 8.0),
      child: TextField(
        controller: txtEditingController,
        keyboardType: keyboardType,
        decoration: inputDecoration(
            labelText: label,
            prefixIcon: prefixIcon,
            enableBorderColor: enabledBorderColor,
            focusBorderColor: focusedBorderColor,
        errorText: showError),
      ),
    );
  }
}

InputDecoration inputDecoration({
  required Icon prefixIcon,
  required String labelText,
  bool? errorText,
  Color? enableBorderColor,
  Color? focusBorderColor,
}) {
  return InputDecoration(
    labelStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    contentPadding: const EdgeInsets.only(left: 40,top: 50),
    prefixIcon: prefixIcon,
    labelText: labelText,
    errorText: errorText != null ? 'Empty or invalid input' : null,
    enabledBorder: enableInputBorder(enableBorderColor ?? Colors.blue),
    focusedBorder: focusInputBorder(focusBorderColor ?? Colors.blueAccent),
  );
}

OutlineInputBorder focusInputBorder(Color myColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: myColor,
      width: 3.0,
    ),
  );
}

OutlineInputBorder enableInputBorder(Color myColor) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: myColor,
      width: 2.0,
    ),
  );
}
