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
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
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
                    onCompleted: (value) {
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
                        if (otpCode != null) {
                          _isOtpVerified = await verifyOTP(otpCode!);
                        } else {
                          AppSnackbar.showErrorSnackBar(
                              context, 'Enter proper 6-digit code');
                        }

                        if (_isOtpVerified) {
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
                        } else {
                          if (!mounted) return;
                          AppSnackbar.showErrorSnackBar(
                              context, "Could not verify OTP!");
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

  Future<bool> verifyOTP(String userOtp) async {
    var credentials = await _firebaseAuth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: widget.verificationId, smsCode: userOtp));
    userCredentials = credentials;
    if (kDebugMode) {
      print(userCredentials.user!.uid.toString());
    }
    return credentials.user != null ? true : false;
  }
}
