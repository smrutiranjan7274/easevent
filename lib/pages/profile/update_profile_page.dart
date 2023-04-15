import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easevent/storage/storage_repo.dart';
import 'package:easevent/utils/app_button.dart';
import 'package:easevent/utils/app_color.dart';
import 'package:easevent/utils/app_snackbar.dart';
import 'package:easevent/utils/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  File _image = File('assets/icons/blank_profile_picture.png');

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String firstName = user.displayName!.split(' ')[0];
    String lastName = user.displayName!.split(' ')[1];
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                const SizedBox(height: 10),

                ListTile(
                  title: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: AppColors.mPrimaryAccent[200],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Change Profile Picture',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // First Name
                AppTextField(
                  hintText: "First Name",
                  isPassword: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),

                // Last Name
                AppTextField(
                  hintText: "Last Name",
                  isPassword: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
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
      user.updateDisplayName(
          '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}');
      user.updatePhotoURL(profileImageURL);

      // Update User Details in Firebase Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update(
        {
          'first name': _firstNameController.text.trim(),
          'last name': _lastNameController.text.trim(),
          'photoURL': user.photoURL,
        },
      );
      if (!mounted) return;
      // Show success snackbar
      return AppSnackbar.showSuccessSnackBar(
          context, 'Profile Updated Successfully!');
    } finally {
      Navigator.of(context).pop();
    }
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
    try {
      await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50)
          .then(
            (image) => setState(
              () {
                _image = File(image!.path);
              },
            ),
          );
    } catch (e) {
      return AppSnackbar.showErrorSnackBar(context, "Please capture an image!");
    }
  }

  Future _imgFromGallery() async {
    try {
      await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50)
          .then(
            (image) => setState(
              () {
                _image = File(image!.path);
              },
            ),
          );
    } catch (e) {
      return AppSnackbar.showErrorSnackBar(
          context, "Please select a valid image!");
    }
  }
}
