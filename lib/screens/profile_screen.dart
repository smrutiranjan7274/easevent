import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/screens/update_profile_screen.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: getUserDetails(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return userProfileWithDetails(context, snapshot.data);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
      ),
    );
  }

  Widget userProfileWithDetails(context, snapshot) {
    final user = FirebaseAuth.instance.currentUser!;

    // Temporary Profile Image
    String profileImagePath = 'assets/icons/3d_person.jpg';

    // Image from Firebase
    String? profileImageURL = user.photoURL;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: profileImageURL == null
                      ? DecorationImage(
                          image: AssetImage(profileImagePath),
                          fit: BoxFit.cover,
                        )
                      : DecorationImage(
                          image: NetworkImage(profileImageURL),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  color: AppColors.mPrimaryAccent.withOpacity(0.5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_circle_rounded,
                      color: Colors.black,
                      size: 40,
                    ),
                    // Current User Display Name
                    title: Text(
                      user.displayName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Current User Email
                    subtitle: Text(
                      user.email!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UpdateProfile(),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.cPrimaryAccent.withOpacity(0.5),
                    child: const ListTile(
                      title: Text(
                        'Edit Profile',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () async {
                String url =
                    "https://docs.google.com/forms/d/e/1FAIpQLScAh2iwNrNl-tepxPKDjMqfVWHddod5WGcHXKv6-5kl-pc4bg/viewform";
                _launchUrl(url);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.cPrimaryAccent.withOpacity(0.5),
                    child: const ListTile(
                      title: Text(
                        'Feedback',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  color: AppColors.cPrimaryAccent.withOpacity(0.5),
                  child: const ListTile(
                    title: Text(
                      'Request to Delete Account',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: signOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    color: AppColors.cError.withOpacity(0.69),
                    child: const ListTile(
                      trailing: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Launch Feedback Form URL
  _launchUrl(String url) async {
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    }
  }

  // Getting user details from Firebase
  Future getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc;
  }

  // Sign Out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
