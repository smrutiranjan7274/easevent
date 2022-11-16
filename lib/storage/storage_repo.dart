import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageRepo {
  // String bucket = 'gs://easevent-c1fbb.appspot.com';
  FirebaseStorage storage = FirebaseStorage.instanceFor(
    bucket: 'gs://easevent-c1fbb.appspot.com',
  );

  Future<String> uploadFile(File file, String path) async {
    try {
      var storageRef = storage.ref().child(path);
      var uploadTask = storageRef.putFile(File(file.path));
      var completedTask = await uploadTask.whenComplete(() => null);
      var downloadURL = await completedTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return '';
    }
  }
}
