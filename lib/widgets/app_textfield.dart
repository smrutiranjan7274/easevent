// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;

  const AppTextField(
      {super.key, required this.hintText, required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cTextFieldBackground,
          border: Border.all(
            color: AppColors.cSecondaryAccent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
