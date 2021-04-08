import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDataStoreService {
  FirebaseDataStoreService._();

  factory FirebaseDataStoreService() => _instance;

  static final FirebaseDataStoreService _instance = FirebaseDataStoreService._();

  Future<TaskSnapshot> uploadPic(File selectedUserImage, String userAccount) {
    var firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('product')
        .child(userAccount)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    return firebaseStorageRef.putFile(selectedUserImage);
  }
}
