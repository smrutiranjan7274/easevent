// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_snackbar.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({
    Key? key,
    required this.showRegisterPage,
  }) : super(key: key);

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
            physics: const BouncingScrollPhysics(),
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
                  'Welcome back!',
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
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 20),

                // Password Textfield
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: _isHidden,
                  keyboardType: TextInputType.visiblePassword,
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
                    Text(
                      'Not a member yet? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: AppColors.cSecondary,
                          fontWeight: FontWeight.w600,
                        ),
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
    if (isValidEmail() && isValidPassword()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AppSnackbar.showErrorSnackBar(
              context, 'No account found for that email.');
        } else if (e.code == 'wrong-password') {
          AppSnackbar.showErrorSnackBar(
              context, 'The password that you\'ve entered is incorrect.');
        }
      } catch (e) {
        AppSnackbar.showErrorSnackBar(
            context, 'Something went wrong! Please try again later.');
      }
    }
  }

  bool isValidEmail() {
    String email = _emailController.text.trim();

    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(email);

    if (_emailController.text.trim().isEmpty) {
      AppSnackbar.showErrorSnackBar(context, 'Email can not be empty!');
      return false;
    } else if (!emailValid) {
      AppSnackbar.showErrorSnackBar(context, 'Email is not valid!');
      return false;
    } else {
      return true;
    }
  }

  bool isValidPassword() {
    if (_passwordController.text.trim().isEmpty) {
      AppSnackbar.showErrorSnackBar(context, 'Password can not be empty!');
      return false;
    } else {
      return true;
    }
  }
}
