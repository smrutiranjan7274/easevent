// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:easevent/widgets/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    super.key,
    required this.showLoginPage,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create text controllers for textfield
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isHidden = true;

  // Dispose text controllers
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Welcome to Easevent!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 10),
                Text(
                  'Register to continue!',
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
                SizedBox(height: 20),

                // Confirm Password Textfield
                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: _isHidden,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock),
                ),

                // Toggle Show password
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
                  text: 'Sign Up',
                  onPressed: signUp,
                ),
                SizedBox(height: 30),

                // Register Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member? ',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text(
                        'Sign In',
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

  // Sign Up Function
  Future signUp() async {
    if (isValidEmail() && passwordMatch()) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        //ignore:avoid_print
        // print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AppSnackbar.showErrorSnackBar(
              context, 'The password provided is too weak or short!');
          //ignore:avoid_print
          // print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          AppSnackbar.showErrorSnackBar(
              context, 'An account already exists for that email.');
          //ignore:avoid_print
          //print('An account already exists for that email.');
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

  bool passwordMatch() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      AppSnackbar.showErrorSnackBar(context, 'Passwords do not match!');
      return false;
    }
  }
}
