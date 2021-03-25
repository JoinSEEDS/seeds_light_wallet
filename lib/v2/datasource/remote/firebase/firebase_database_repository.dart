import 'package:cloud_firestore/cloud_firestore.dart';

const String FIREBASE_DATABASE_USERS_TOKEN = 'users';
abstract class FirebaseDatabaseService {
  CollectionReference get usersCollection => FirebaseFirestore.instance.collection(FIREBASE_DATABASE_USERS_TOKEN);
}
