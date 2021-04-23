import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String FIREBASE_DATABASE_USERS_TOKEN = 'users';
const String GUARDIAN_NOTIFICATION_KEY = 'guardianNotification';
const String PENDING_NOTIFICATIONS_KEY = 'pendingNotifications';

abstract class FirebaseDatabaseService {
  CollectionReference get usersCollection => FirebaseFirestore.instance.collection(FIREBASE_DATABASE_USERS_TOKEN);

  Stream<bool> hasGuardianNotificationPending(String userAccount) {
    bool _findNotification(QuerySnapshot event) {
      QueryDocumentSnapshot? guardianNotification = event.docs.firstWhereOrNull(
        (QueryDocumentSnapshot? element) => element?.id == GUARDIAN_NOTIFICATION_KEY,
      );

      if (guardianNotification == null) {
        return false;
      } else {
        return guardianNotification[GUARDIAN_NOTIFICATION_KEY];
      }
    }

    return usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .snapshots()
        .map((event) => _findNotification(event));
  }
}
