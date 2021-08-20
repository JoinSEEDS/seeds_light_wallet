import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDataStoreService {
  factory FirebaseDataStoreService() => _instance;

  FirebaseDataStoreService._();

  static final FirebaseDataStoreService _instance = FirebaseDataStoreService._();

  Future<TaskSnapshot> uploadPic(File selectedUserImage, String userAccount) {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('product')
        .child(userAccount)
        .child(DateTime.now().millisecondsSinceEpoch.toString());

    return firebaseStorageRef.putFile(selectedUserImage);
  }
}
