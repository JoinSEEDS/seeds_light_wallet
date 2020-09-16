import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/push_notification_service.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService._();

  factory FirebaseDatabaseService() => _instance;

  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._();

  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  setFirebaseMessageToken(String userId) {
    // Users can have multiple tokens. Ex: Multiple devices.
    List<String> tokens = [PushNotificationService().token];
    Map<String, Object> data = {
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayUnion(tokens),
    };

    _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  removeFirebaseMessageToken(String userId) {
    List<String> tokens = [PushNotificationService().token];
    Map<String, Object> data = {
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayRemove(tokens),
    };

    _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }
}
