import 'package:flutter/material.dart';
import '../res/app_colors/app_colors.dart';

class CustomTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
  const CustomTextFields({
    required this.controller,
    required this.hintText,
    required this.obscure,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: hintText,
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)), borderSide: BorderSide(color: AppColors.primary)),
      ),
    );
  }
}
