// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Get Current User
  final user = FirebaseAuth.instance.currentUser!;

  // Is loading
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              elevation: 0,
              actions: [
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : IconButton(
                        onPressed: signOut,
                        icon: const Icon(Icons.logout),
                      ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${user.email!}'),
                ],
              ),
            ),
          );
  }

  Future signOut() async {
    // Set loading to true
    setState(() {
      _isLoading = true;
    });

    // Sign Out
    await FirebaseAuth.instance.signOut();

    // Set loading to false
    setState(() {
      _isLoading = false;
    });
  }
}
