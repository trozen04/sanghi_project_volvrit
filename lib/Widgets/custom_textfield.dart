import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppShadows.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? errorText; // optional manual override
  final void Function(String)? onChanged;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
    this.errorText,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadows.boxShadow,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        onChanged: onChanged,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: FFontStyles.hintText(14),
          errorText: errorText, // lets you manually override if needed
          errorStyle: const TextStyle(
            color: AppColors.logoutColor,
            fontSize: 12,
            height: 1.2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: height * 0.015,
            horizontal: width * 0.03,
          ),
          isDense: true,
          alignLabelWithHint: true,
          counterText: '', // hides the default counter
        ),
      ),
    );
  }
}
