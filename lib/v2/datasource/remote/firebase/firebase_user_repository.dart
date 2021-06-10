import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_user_model.dart';

class FirebaseUserRepository extends FirebaseDatabaseService {
  Stream<FirebaseUserModel> getUserData(String accountName) {
    return usersCollection
        .doc(accountName)
        .snapshots()
        .map((DocumentSnapshot userData) => FirebaseUserModel.fromDocument(userData as Map<String, dynamic>, accountName));
  }
}
