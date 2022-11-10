import 'package:flutter/material.dart';

class AppColors {
  // Material Color Palette
  static MaterialColor mPrimary = const MaterialColor(0xFF3A0CA3, {
    50: Color(0xFFEAE2F8),
    100: Color(0xFFCFBCF2),
    200: Color(0xFFA081D9),
    300: Color(0xFF8466B7),
    400: Color(0xFF653DA0),
    500: Color(0xFF3A0CA3),
    600: Color(0xFF3A0CA3),
    700: Color(0xFF3A0CA3),
    800: Color(0xFF3A0CA3),
  });
  static MaterialColor mPrimaryAccent = const MaterialColor(0xFF4361EE, {
    50: Color(0xFFEBF0FF),
    100: Color(0xFFD6E2FF),
    200: Color(0xFFA6C1FF),
    300: Color(0xFF7795FF),
    400: Color(0xFF597EF7),
    500: Color(0xFF4361EE),
    600: Color(0xFF4361EE),
    700: Color(0xFF4361EE),
    800: Color(0xFF4361EE),
  });
  static MaterialColor mSecondary = const MaterialColor(0xFFF72585, {
    50: Color(0xFFFFE0F0),
    100: Color(0xFFFFB5DA),
    200: Color(0xFFF370AB),
    300: Color(0xFFE6007A),
    400: Color(0xFFD6006E),
    500: Color(0xFFF72585),
    600: Color(0xFFF72585),
    700: Color(0xFFF72585),
    800: Color(0xFFF72585),
  });
  static MaterialColor mSecondaryAccent = const MaterialColor(0xFF7209B7, {
    50: Color(0xFFEDEBFF),
    100: Color(0xFFD6BAFF),
    200: Color(0xFFB779FF),
    300: Color(0xFF7209B7),
    400: Color(0xFF7209B7),
    500: Color(0xFF7209B7),
    600: Color(0xFF7209B7),
    700: Color(0xFF7209B7),
    800: Color(0xFF7209B7),
  });

  // Custom Colors
  static Color cPrimary = const Color(0xFF3F37C9);
  static Color cPrimaryAccent = const Color(0xFF4895EF);
  static Color cSecondary = const Color(0xFFB5179E);
  static Color cSecondaryAccent = const Color(0xFF560BAD);

  static Color cBackground = const Color.fromARGB(255, 178, 178, 178);
  static Color cTextFieldBackground = const Color.fromARGB(255, 241, 241, 241);
  static Color cError = const Color.fromARGB(255, 192, 10, 10);
  static Color cSuccess = const Color.fromARGB(255, 2, 159, 2);
}
