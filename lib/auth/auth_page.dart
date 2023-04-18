import 'package:easevent/pages/auth_pages/login_page.dart';
import 'package:easevent/pages/auth_pages/phone.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_snackbar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late ConnectivityResult _previousResult;

  @override
  void initState() {
    super.initState();

    // Subscribe to connectivity changes
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      showConnectivitySnackBar(context, result);
    });

    // Check the initial connectivity state
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      setState(() {
        _previousResult = result; // Set the initial value of _previousResult
      });
      if (result == ConnectivityResult.none) {
        showConnectivitySnackBar(context, result);
      }
    });
  }

  // Initially, show the login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(showRegisterPage: toggleScreens);
    } else {
      return RegisterWithPhone(showLoginPage: toggleScreens);
    }
  }

  void showConnectivitySnackBar(
      BuildContext context, ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      AppSnackbar.showErrorSnackBar(context, 'No Connection!');
    } else if (result != ConnectivityResult.none &&
        _previousResult == ConnectivityResult.none) {
      AppSnackbar.showSuccessSnackBar(context, 'Back online');
    }
    _previousResult = result;
  }
}
