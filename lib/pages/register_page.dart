// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/widgets/app_button.dart';
import 'package:easevent/widgets/app_textfield.dart';
import 'package:easevent/widgets/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // To show/hide password
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
                  height: 100,
                ),
                SizedBox(height: 20),
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

                // First Name Textfield
                AppTextField(
                  controller: _firstNameController,
                  hintText: 'First Name',
                  isPassword: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                SizedBox(height: 10),

                // Last Name Textfield
                AppTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  isPassword: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                SizedBox(height: 10),

                // Email Textfield
                AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 10),

                // Password Textfield
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: _isHidden,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock),
                ),
                SizedBox(height: 10),

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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: _togglePassowrdView,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          minimumSize: MaterialStateProperty.all(Size.zero),
                        ),
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
                      Text(
                        'Show Password ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
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
                SizedBox(height: 20),

                SizedBox(
                  width: Get.width * 0.8,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'By signing up, you agree our ',
                            style: TextStyle(
                                color: Color(0xff262628), fontSize: 12)),
                        TextSpan(
                          text: 'terms, data policy and cookies policy',
                          style: TextStyle(
                              color: Color(0xff262628),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
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
                          color: AppColors.cPrimaryAccent,
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
    // Get text from textfield
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (isValidEmail() && passwordMatch()) {
      try {
        // Create user
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // After user created, add user details to firestore
        addUserDetails(
          firstName,
          lastName,
          email,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AppSnackbar.showErrorSnackBar(
              context, 'The password provided is too weak or short !');
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
    // Pop loading circle
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  Future addUserDetails(String firstName, String lastName, String email) async {
    await FirebaseFirestore.instance.collection('users').add(
      {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      },
    );
  }

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

  bool passwordMatch() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      AppSnackbar.showErrorSnackBar(context, 'Passwords do not match !');
      return false;
    }
  }
}
