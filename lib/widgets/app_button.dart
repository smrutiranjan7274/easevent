// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  const AppButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cPrimary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
