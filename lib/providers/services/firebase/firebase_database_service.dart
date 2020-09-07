import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService._();

  factory FirebaseDatabaseService() => _instance;

  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._();

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  setFirebaseMessageToken(String token, String userId) {
    // Users can have multiple tokens. Ex: Multiple devices.
    List<String> tokens = [token];
    Map<String, Object> data = {
      FIREBASE_MESSAGE_TOKEN_KEY: FieldValue.arrayUnion(tokens),
    };
    usersCollection.doc(userId).update(data);
  }
}
