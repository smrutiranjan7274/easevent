import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/storage/storage_repo.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/app_snackbar.dart';
import 'package:easevent/utils/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final user = FirebaseAuth.instance.currentUser!;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  File _image = File('assets/icons/blank_profile_picture.png');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Edit Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                ListTile(
                  title: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(_image.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // First Name
                AppTextField(
                  hintText: "First Name",
                  isPassword: false,
                  textCapitalization: TextCapitalization.words,
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Last Name
                AppTextField(
                  hintText: "Last Name",
                  isPassword: false,
                  textCapitalization: TextCapitalization.words,
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Email
                AppTextField(
                  hintText: "Email",
                  isPassword: false,
                  textCapitalization: TextCapitalization.none,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),

                // Update Button
                AppButton(
                  text: "Update",
                  onPressed: () async {
                    // Update User Details in Firebase Firestore
                    await updateUserDetails();

                    if (!mounted) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updating user details in Firebase
  Future<void> updateUserDetails() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Upload Profile Image to Firebase Storage
      String profileImageURL =
          await StorageRepo().uploadFile(_image, 'user/profile/${user.uid}');
      final uid = user.uid;
      // Update User Profile in Firebase Fireauth
      await user.updateEmail(_emailController.text.trim());
      await user.updateDisplayName(
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}');
      await user.updatePhotoURL(profileImageURL);

      // Update User Details in Firebase Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'first name': _firstNameController.text.trim(),
          'last name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'photoURL': profileImageURL,
        },
      );
      if (!mounted) return;
      // Show success snackbar
      return AppSnackbar.showSuccessSnackBar(
          context, 'Profile Updated Successfully!');
    } on FirebaseAuthException catch (e) {
      // print(e);
      if (e.code == 'requires-recent-login') {
        return AppSnackbar.showErrorSnackBar(
            context, 'Please re-login to update your profile');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return AppSnackbar.showErrorSnackBar(
          context, 'Error updating your profile. Please try again later!');
    }

    // Pop loading circle
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                textColor: AppColors.mPrimaryAccent,
                iconColor: AppColors.mPrimaryAccent,
                title: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                textColor: AppColors.mPrimaryAccent,
                iconColor: AppColors.mPrimaryAccent,
                title: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _imgFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future _imgFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _image = File(pickedFile!.path);
    });
  }
}
