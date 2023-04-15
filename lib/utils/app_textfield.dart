// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:easevent/utils/app_color.dart';

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

  final int? length;
  final List<TextInputFormatter>? inputFormatters;

  // InkWell? suffix;

  const AppTextField({
    Key? key,
    required this.hintText,
    required this.isPassword,
    this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    required this.textCapitalization,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.enabled,
    this.inputFormatters,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        maxLength: length,
        inputFormatters: inputFormatters,
        enabled: enabled,
        minLines: minLines,
        maxLines: maxLines,
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF3F37C9),
          ),
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
