import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/models/firebase/GuardianStatus.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/push_notification_service.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService._();

  factory FirebaseDatabaseService() => _instance;

  static final FirebaseDatabaseService _instance = FirebaseDatabaseService._();

  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> setFirebaseMessageToken(String userId) {
    // Users can have multiple tokens. Ex: Multiple devices.
    List<String> tokens = [PushNotificationService().token];
    Map<String, Object> data = {
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayUnion(tokens),
    };

    return _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> removeFirebaseMessageToken(String userId) {
    List<String> tokens = [PushNotificationService().token];
    Map<String, Object> data = {
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayRemove(tokens),
    };

    return _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> sendGuardiansInvite(String currentUserId, List<MemberModel> usersToInvite) {
    var batch = FirebaseFirestore.instance.batch();

    usersToInvite.forEach((user) {
      Map<String, Object> data = {
        UID_KEY: user.account,
        TYPE_KEY: GuardianType.myGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestSent.name,
        GUARDIANS_DATE_SENT_KEY: FieldValue.serverTimestamp(),
      };

      Map<String, Object> dataOther = {
        UID_KEY: currentUserId,
        TYPE_KEY: GuardianType.imGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestedMe.name,
        GUARDIANS_DATE_SENT_KEY: FieldValue.serverTimestamp(),
      };

      var docRef = _usersCollection.doc(currentUserId).collection(GUARDIANS_COLLECTION_KEY).doc(user.account);
      var docRefOther = _usersCollection.doc(user.account).collection(GUARDIANS_COLLECTION_KEY).doc(currentUserId);

      batch.set(docRef, data, SetOptions(merge: true));
      batch.set(docRefOther, dataOther, SetOptions(merge: true));
    });

    return batch.commit();
  }
}
