import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/auth/main_page.dart';
import 'package:easevent/pages/auth_pages/register_page.dart';
import 'package:easevent/utils/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../utils/app_button.dart';
import '../../utils/app_color.dart';

class VerifyOtp extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const VerifyOtp(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? otpCode;
  bool _isOtpVerified = false;
  late UserCredential userCredentials;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border:
            Border.all(color: const Color.fromRGBO(234, 239, 243, 1), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border:
          Border.all(color: const Color.fromRGBO(114, 178, 238, 1), width: 2),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.cPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/name_logo.png',
                    height: 100,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/otp.jpg',
                      width: 200, // Set the width of the image
                      height: 200, // Set the height of the image
                    ),
                  ),
                  const Text(
                    'Please verify your phone number',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "We have sent a OTP on ",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.cPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.cSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    length: 6,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onChanged: (value) {
                      if (kDebugMode) {
                        print(value);
                      }
                      setState(() {
                        otpCode = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                      text: 'Verify OTP',
                      onPressed: () async {
                        // Show loading circle
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );

                        if (otpCode.toString().length == 6) {
                          _isOtpVerified = await verifyOTP(otpCode!);
                        } else if (otpCode.toString().length < 6 ||
                            otpCode == null) {
                          AppSnackbar.showErrorSnackBar(
                              context, 'Enter proper 6-digit code');
                        }

                        if (_isOtpVerified) {
                          String? userId =
                              FirebaseAuth.instance.currentUser?.uid.toString();
                          bool userExist = await doesDocumentExist(userId);
                          if (userExist) {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ),
                            );
                          } else {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(
                                  userCredentials: userCredentials,
                                  showLoginPage: () {},
                                ),
                              ),
                            );
                          }
                        }
                      }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context, (route) => false);
                        },
                        child: Text(
                          widget.phoneNumber,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.cSecondary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Not your number ?",
                        style: TextStyle(
                          color: AppColors.cBackground,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> doesDocumentExist(String? userId) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return snapshot.exists;
  }

  Future<bool> verifyOTP(String userOtp) async {
    try {
      var credentials = await _firebaseAuth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: widget.verificationId, smsCode: userOtp));
      userCredentials = credentials;
      if (kDebugMode) {
        print(userCredentials.user!.uid.toString());
      }
      return credentials.user != null ? true : false;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      if (e.code == 'invalid-verification-code') {
        AppSnackbar.showErrorSnackBar(context, 'Invalid OTP!');
      }
    }
    return false;
  }
}
