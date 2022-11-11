// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    String profileImagePath = 'assets/icons/3d_person.jpg';
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Profile Image
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.asset(
                    profileImagePath,
                    width: Get.width * 0.4,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Current User Display Name
            Text(
              user.displayName!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: 20),

            // Current User Email
            Text(
              user.email!,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            // SizedBox(height: 20),

            // Current User Phone Number
            FutureBuilder(
              future: getUserDetails(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString(),
                  );
                } else {
                  return const Text('Loading...');
                }
              },
            ),
            SizedBox(height: 20),

            // Sign Out Button
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.cError),
              ),
              onPressed: signOut,
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.get('phone number');
  }

  // Sign Out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
