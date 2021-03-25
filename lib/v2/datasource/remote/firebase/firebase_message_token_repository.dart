import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/firebase/push_notification_service.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';

const String FIREBASE_MESSAGE_TOKENS_KEY = 'firebaseMessageTokens';

class FirebaseMessageTokenRepository extends FirebaseDatabaseService {
  Future<void> setFirebaseMessageToken(String userId) {
    // Users can have multiple tokens. Ex: Multiple devices.
    var tokens = <String>[PushNotificationService().token];
    var data = <String, Object>{
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayUnion(tokens),
    };

    return usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> removeFirebaseMessageToken(String userId) {
    var tokens = <String>[PushNotificationService().token];
    var data = <String, Object>{
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayRemove(tokens),
    };

    return usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }
}
