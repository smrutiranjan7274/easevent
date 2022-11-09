// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                // SizedBox(height: 20),
                Image.asset(
                  'assets/logo/logo.png',
                  height: 200,
                ),

                // Greeting
                Text(
                  'Welcome to Easevent!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 10),
                Text(
                  'Sign in to continue!',
                  style: TextStyle(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 40),

                // Email Textfield
                AppTextField(
                  hintText: 'Email',
                  isPassword: false,
                ),
                SizedBox(height: 20),

                // Password Textfield
                AppTextField(
                  hintText: 'Password',
                  isPassword: true,
                ),
                SizedBox(height: 20),

                // Login Button
                AppButton(text: 'Sign In'),
                SizedBox(height: 30),

                // Register Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Not a member yet? ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                        )),
                    Text(
                      'Register Now',
                      style: TextStyle(
                        color: AppColors.cSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
