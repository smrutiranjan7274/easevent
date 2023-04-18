import 'package:easevent/screens/events/events_screen.dart';
import 'package:easevent/screens/explore/explore_screen.dart';
import 'package:easevent/screens/profile/profile_screen.dart';
import 'package:easevent/utils/app_snackbar.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Screens
  final List<Widget> screens = [
    const ExploreScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  // Buttom Navigation Bar Index
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Home Page',
      child: Scaffold(
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore_rounded),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.event_outlined),
                selectedIcon: Icon(Icons.event_rounded),
                label: 'Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
        body: screens[_selectedIndex],
      ),
    );
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
