import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
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

    usersToInvite.forEach((guardian) {
      Map<String, Object> data = {
        UID_KEY: guardian.account,
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

      DocumentReference otherUserRef = _usersCollection.doc(guardian.account);
      DocumentReference currentUserRef =
          _usersCollection.doc(currentUserId).collection(GUARDIANS_COLLECTION_KEY).doc(guardian.account);
      DocumentReference otherUserGuardianRef = otherUserRef.collection(GUARDIANS_COLLECTION_KEY).doc(currentUserId);

      // This empty is needed in case the user does not exist in the database yet. Create him.
      batch.set(otherUserRef, {}, SetOptions(merge: true));
      batch.set(currentUserRef, data, SetOptions(merge: true));
      batch.set(otherUserGuardianRef, dataOther, SetOptions(merge: true));
    });

    return batch.commit();
  }

  Stream<QuerySnapshot> getAllUserGuardians(String uid) {
    return _usersCollection.doc(uid).collection(GUARDIANS_COLLECTION_KEY).snapshots();
  }

  Future<QuerySnapshot> getGuardiansCount(String uid) {
    return _usersCollection.doc(uid).collection(GUARDIANS_COLLECTION_KEY).get();
  }

  Stream<QuerySnapshot> getMyGuardians(String uid) {
    return _usersCollection
        .doc(uid)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .snapshots();
  }

  Stream<QuerySnapshot> getImGuardiansFor(String uid) {
    return _usersCollection
        .doc(uid)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.imGuardian.name)
        .snapshots();
  }

  Future<void> cancelGuardianRequest({String currentUserId, String friendId}) {
    return _deleteGuardianFromUsers(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> removeGuardianGuardian({String currentUserId, String friendId}) {
    return _deleteGuardianFromUsers(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> _deleteGuardianFromUsers({String currentUserId, String friendId}) {
    var batch = FirebaseFirestore.instance.batch();

    var docRef = _usersCollection.doc(currentUserId).collection(GUARDIANS_COLLECTION_KEY).doc(friendId);
    var docRefOther = _usersCollection.doc(friendId).collection(GUARDIANS_COLLECTION_KEY).doc(currentUserId);

    batch.delete(docRef);
    batch.delete(docRefOther);

    return batch.commit();
  }
}
