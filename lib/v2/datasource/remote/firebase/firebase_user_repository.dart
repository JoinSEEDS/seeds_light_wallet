import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_user_model.dart';

class FirebaseUserRepository extends FirebaseDatabaseService {
  Stream<FirebaseUserModel> getUserData(String accountName) {
    return usersCollection
        .doc(accountName)
        .snapshots()
        .map((DocumentSnapshot userData) => FirebaseUserModel.fromDocument(
              userData.data()! as Map<String, dynamic>,
              accountName,
            ));
  }

  Future<void> saveUserPhoneNumber(String userId, phoneNumber) {
    Map<String, Object> data = {
      USER_PHONE_NUMBER_KEY: phoneNumber,
    };

    return usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }
}
