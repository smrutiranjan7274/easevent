// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_textfield.dart';
import 'package:easevent/utils/app_snackbar.dart';
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
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
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person),
                ),
                SizedBox(height: 10),

                // Last Name Textfield
                AppTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name',
                  isPassword: false,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.person),
                ),
                SizedBox(height: 10),

                // Email Textfield
                AppTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  isPassword: false,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.none,
                  prefixIcon: Icon(Icons.email),
                ),
                SizedBox(height: 10),

                // Phone Textfield
                AppTextField(
                  controller: _phoneController,
                  hintText: 'Phone',
                  isPassword: false,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.none,
                  prefixIcon: Icon(Icons.phone),
                ),
                SizedBox(height: 10),

                // Password Textfield
                AppTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: _isHidden,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock),
                ),
                SizedBox(height: 10),

                // Confirm Password Textfield
                AppTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: _isHidden,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: Icon(Icons.lock),
                ),

                // Toggle Password Visibility
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _togglePassowrdView,
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                        ),
                        child: Row(
                          children: [
                            Text('  '),
                            _isHidden
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            Text('  Password  ')
                          ],
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
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String email = _emailController.text.trim();
    final String phoneNumber = _phoneController.text.trim();

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    if (isValidEmail() && passwordMatch() && isValidPhone()) {
      try {
        // Create user
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update user display name & email
        userCredential.user!.updateDisplayName('$firstName $lastName');
        userCredential.user!.updateEmail(email);

        String userUID = userCredential.user!.uid;

        // After user created, add user details to firestore
        addUserDetails(userUID, firstName, lastName, email, phoneNumber);
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
    if (!mounted) return;
    Navigator.of(context).pop();

    // Sign Up Success and Sign Out then Navigate to Login Page
    await FirebaseAuth.instance.signOut();
  }

  Future addUserDetails(String userUID, String firstName, String lastName,
      String email, String phoneNumber) async {
    await FirebaseFirestore.instance.collection('users').doc(userUID).set(
      {
        'uid': userUID,
        'first name': firstName,
        'last name': lastName,
        'email': email,
        'phone number': phoneNumber,
        'photoURL': '',
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

  bool isValidPhone() {
    String phone = _phoneController.text.trim();
    final bool phoneValid =
        RegExp(r"^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}$")
            .hasMatch(phone);
    if (_phoneController.text.trim().isEmpty) {
      AppSnackbar.showErrorSnackBar(context, 'Phone number can not be empty !');
      return false;
    } else if (!phoneValid) {
      AppSnackbar.showErrorSnackBar(context, 'Phone number is not valid !');
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
