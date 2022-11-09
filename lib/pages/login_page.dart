// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create text controllers for textfield
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isHidden = true;

  // Dispose text controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePassowrdView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

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
                  controller: _emailController,
                  hintText: 'Email',
                  isPassword: false,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 20),

                // Password Textfield
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: _isHidden,
                  prefixIcon: Icon(Icons.lock),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Show Password ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _togglePassowrdView,
                        child: Checkbox(
                          value: !_isHidden,
                          onChanged: (value) {
                            _togglePassowrdView();
                          },
                          activeColor: AppColors.cPrimaryAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Login Button
                AppButton(
                  text: 'Sign In',
                  onPressed: signIn,
                ),
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

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }
}
