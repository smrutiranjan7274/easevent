// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  TextEditingController? controller;
  Icon? suffixIcon;
  Icon? prefixIcon;
  TextInputType? keyboardType;
  TextCapitalization textCapitalization;
  TextInputAction? textInputAction;

  // InkWell? suffix;

  AppTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.textCapitalization,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          label: Text(hintText),
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
