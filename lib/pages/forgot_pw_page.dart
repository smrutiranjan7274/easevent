// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_snackbar.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.title});

  final String title;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Create text controllers for textfields
  final _emailController = TextEditingController();

  // Dispose text controllers
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Enter your email and we will send you a password reset link',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.cPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            AppTextField(
              controller: _emailController,
              hintText: 'Email',
              isPassword: false,
              prefixIcon: const Icon(Icons.email),
            ),
            SizedBox(height: 20),
            AppButton(
              text: 'Reset Password',
              onPressed: passwordReset,
            )
          ],
        ),
      ),
    );
  }

  // Function to send reset password link to email
  Future passwordReset() async {
    if (isValidEmail()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        // ignore: use_build_context_synchronously
        AppSnackbar.showSuccessSnackBar(
          context,
          'Password reset link sent to ${_emailController.text.trim()}',
        );

        // Push Back to Login Page
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AppSnackbar.showErrorSnackBar(
            context,
            'No user found for that email !',
          );
        }
      } catch (e) {
        AppSnackbar.showErrorSnackBar(
          context,
          'Something went wrong, try again later !',
        );
      }
    }
  }

  // Check if email is valid
  bool isValidEmail() {
    String email = _emailController.text.trim();

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (_emailController.text.trim().isEmpty) {
      AppSnackbar.showErrorSnackBar(context, 'Email can not be empty !');
      return false;
    } else if (!emailValid) {
      AppSnackbar.showErrorSnackBar(context, 'Email is not valid !');
      return false;
    } else {
      return true;
    }
  }
}
