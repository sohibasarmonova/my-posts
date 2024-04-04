
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myposts/services/prefs_service.dart';
import 'dart:io';

import 'auth_service.dart';

class FileService {
  static final _storage = FirebaseStorage.instance.ref();
  static const folder_post = "post_images";

  static Future<String> uploadPostImage(File _image) async {
    String uid = await Prefs.loadUserId();
    String img_name = "${uid}_${DateTime.now()}";
    var firebaseStorageRef = _storage.child(folder_post).child(img_name);
    var uploadTask = firebaseStorageRef.putFile(_image);
    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    final String downloadUrl = await firebaseStorageRef.getDownloadURL();
    print(downloadUrl);
    return downloadUrl;
  }
}