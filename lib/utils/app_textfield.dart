import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  final TextEditingController? controller;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  final bool? enabled;

  // InkWell? suffix;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.textCapitalization,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        enabled: enabled,
        minLines: minLines,
        maxLines: maxLines,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          label: Text(
            hintText,
            style: TextStyle(color: AppColors.cPrimary),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          // hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.cBackground,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.cPrimary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
