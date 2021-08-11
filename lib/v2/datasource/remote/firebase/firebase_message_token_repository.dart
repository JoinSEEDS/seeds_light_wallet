import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_push_notification_service.dart';

class FirebaseMessageTokenRepository extends FirebaseDatabaseService {
  Future<void> setFirebaseMessageToken(String? userId) async {
    // Users can have multiple tokens. Ex: Multiple devices.
    if (PushNotificationService().token != null) {
      final tokens = <String?>[PushNotificationService().token];
      final data = <String, Object>{
        FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayUnion(tokens),
      };

      await usersCollection.doc(userId).set(data, SetOptions(merge: true));
    } else {
      print('Error retrieving firebase messaging token');
    }
  }

  Future<void> removeFirebaseMessageToken(String userId) async {
    if (PushNotificationService().token != null) {
      final tokens = <String?>[PushNotificationService().token];
      final data = <String, Object>{
        FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayRemove(tokens),
      };

      await usersCollection.doc(userId).set(data, SetOptions(merge: true));
    } else {
      print('Error retrieving firebase messaging token');
    }
  }
}
