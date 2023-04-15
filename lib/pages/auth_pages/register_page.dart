// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/auth/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:easevent/utils/app_snackbar.dart';

import '../../utils/app_button.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textfield.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  final UserCredential userCredentials;
  const RegisterPage({
    Key? key,
    required this.userCredentials,
    required this.showLoginPage,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
  }

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
    // _phoneController.dispose();
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
      body: Semantics(
        label: 'Register Page',
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  // SizedBox(height: 20),
                  Image.asset(
                    'assets/logo/name_logo.png',
                    height: 100,
                    width: 200,
                  ),
                  // SizedBox(height: 20),
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
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.cBackground,
                    ),
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
                    prefixIcon: Icon(
                      Icons.person,
                      color: AppColors.cBackground,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Email Textfield
                  AppTextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[A-Za-z0-9#+-.@]*"))
                    ],
                    controller: _emailController,
                    hintText: 'Email',
                    isPassword: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color: AppColors.cBackground,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Password Textfield
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: AppColors.cPrimary),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.cBackground,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.cBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.cPrimary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: _isHidden,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: AppColors.cPrimary),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.cBackground,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.cBackground,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.cPrimary,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
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
                            padding:
                                MaterialStateProperty.all(EdgeInsets.all(0)),
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
                ],
              ),
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
        UserCredential userCredential = widget.userCredentials;

        // Update user display name & email
        userCredential.user!.updateDisplayName('$firstName $lastName');
        String userUID = userCredential.user!.uid;
        String phoneNumber = userCredential.user!.phoneNumber.toString();
        // userCredential.user!.updateEmail(email);

        // After user created, add user details to firestore
        addUserDetails(userUID, firstName, lastName, email, phoneNumber);

        AuthCredential credential = EmailAuthProvider.credential(
          email: email,
          password: _confirmPasswordController.text.trim().toString(),
        );
        userCredential.user!.linkWithCredential(credential).then((value) {
          var user = value.user;
          if (kDebugMode) {
            print("Account linking successful for ${user!.email}");
          }
        }).catchError((onError) {
          if (kDebugMode) {
            print("Error linking account: $onError");
          }
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AppSnackbar.showErrorSnackBar(
              context, 'The password provided is too weak or short !');
        } else if (e.code == 'email-already-in-use') {
          AppSnackbar.showErrorSnackBar(
              context, 'An account already exists for that email.');
        }
      } catch (e) {
        AppSnackbar.showErrorSnackBar(
            context, 'Something went wrong! Please try again later.');
      }
    }
    // Pop loading circle
    if (!mounted) return;
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
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
