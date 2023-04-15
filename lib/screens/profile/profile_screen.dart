import 'package:cached_network_image/cached_network_image.dart';
import 'package:easevent/pages/profile/update_profile_page.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/app_snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // if email is verified
  bool _emailVerified = false;

  Future<void> reloadPage() async {
    setState(() {});
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    verifyEmail();
    return SafeArea(
      child: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        onRefresh: reloadPage,
        height: 100,
        animSpeedFactor: 3,
        springAnimationDurationInMilliseconds: 500,
        child: ListView(
          children: [
            FutureBuilder(
              future: getUserDetails(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return userProfileWithDetails(context, snapshot);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
            ),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget userProfileWithDetails(context, snapshot) {
    final user = snapshot.data;
    // print(user);
    // Temporary Profile Image
    String profileImagePath = 'assets/icons/blank_profile_picture.png';
    // Image from Firebase
    String profileImageURL = user.photoURL.toString();
    if (kDebugMode) {
      print(profileImageURL);
    }

    return Semantics(
      label: 'Profile Screen',
      child: SafeArea(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: profileImageURL == 'null'
                        ? Image.asset(
                            profileImagePath,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: profileImageURL,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              Icons.warning_rounded,
                              size: 50,
                              color: AppColors.cError,
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
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

              IgnorePointer(
                ignoring: _emailVerified,
                child: GestureDetector(
                  onTap: () async {
                    if (_emailVerified) {
                      // Show that email is verified already!
                      AppSnackbar.showSuccessSnackBar(
                          context, 'Email Already Verified!');
                    } else {
                      User? user = FirebaseAuth.instance.currentUser;
                      await user?.sendEmailVerification();
                      // Show that email verification link has been sent to the provided email address
                      AppSnackbar.showSuccessSnackBar(context,
                          'Please check your Email for the verification link.');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _emailVerified
                          ? Container(
                              width: double.infinity,
                              color: AppColors.cSuccess.withOpacity(0.5),
                              child: const ListTile(
                                title: Text(
                                  'Email Verified!',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              color: AppColors.cError.withOpacity(0.5),
                              child: const ListTile(
                                title: Text(
                                  'Verify Email',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
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
                      color: AppColors.cError,
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
    return user;
    // final uid = user.uid;
    // final doc =
    //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
    // print(doc.data());
    // return doc;
  }

  // Sign Out
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Check if email is verified
  Future verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      // The user has verified their email
      _emailVerified = true;
    } else {
      // The user has not verified their email
      _emailVerified = false;
    }
  }
}
