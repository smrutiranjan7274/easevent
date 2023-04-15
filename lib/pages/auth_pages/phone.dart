import 'package:country_picker/country_picker.dart';
import 'package:easevent/pages/auth_pages/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_button.dart';
import '../../utils/app_color.dart';
import '../../utils/app_snackbar.dart';

class RegisterWithPhone extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterWithPhone({
    super.key,
    required this.showLoginPage,
  });

  @override
  State<RegisterWithPhone> createState() => _RegisterWithPhoneState();
}

class _RegisterWithPhoneState extends State<RegisterWithPhone> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  var verificationId = ''.obs;

  static Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "india",
      displayNameNoCountryCode: "IN",
      e164Key: "");

  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/name_logo.png',
                    height: 100,
                    width: 250,
                  ),
                  // const SizedBox(height: 20),
                  const Text(
                    'Enter your phone number to continue!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/phone.jpg',
                      width: 200, // Set the width of the image
                      height: 200, // Set the height of the image
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: AppColors.cBackground,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 65,
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                countryListTheme: CountryListThemeData(
                                  bottomSheetHeight: 500,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                onSelect: (value) {
                                  setState(
                                    () {
                                      selectedCountry = value;
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(
                              "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {});
                            },
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            autofillHints: const [
                              AutofillHints.telephoneNumberDevice
                            ],
                            decoration: InputDecoration(
                              hintText: 'Phone',
                              border: InputBorder.none,
                              suffixIcon: Icon(_phoneController.text.length > 9
                                  ? Icons.done
                                  : null),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                      text: 'Send OTP',
                      onPressed: () {
                        String phoneNumber =
                            "+${selectedCountry.phoneCode}${_phoneController.text.trim()}";
                        if (isValidPhone()) {
                          sendOtp(context, phoneNumber);
                        }
                      }),
                  const SizedBox(height: 20),
                  // Already Member Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member? ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.cPrimaryAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendOtp(BuildContext context, String phoneNumber) async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (phoneAuthCredential) async {
            // await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            if (error.code == 'invalid-phone-number') {
              AppSnackbar.showErrorSnackBar(context, error.message.toString());
            } else {
              AppSnackbar.showErrorSnackBar(context, "Something went wrong!");
            }
          },
          codeSent: (verificationId, forceResendingToken) {
            this.verificationId.value = verificationId;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOtp(
                  phoneNumber: phoneNumber,
                  verificationId: verificationId,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId.value = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      AppSnackbar.showErrorSnackBar(context, e.message.toString());
    }

    // Pop loading circle
    if (!mounted) return;
    Navigator.of(context).pop();
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
}
