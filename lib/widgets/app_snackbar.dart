import 'package:easevent/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  // static void showSnackBar(BuildContext context, String message, bool isError) {
  //   if (isError) {
  //     showErrorSnackBar(context, message);
  //   } else {
  //     showSuccessSnackBar(context, message);
  //   }
  // }

  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cSuccess,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.cError,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
