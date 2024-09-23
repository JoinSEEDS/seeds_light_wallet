import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/datasource/remote/model/firebase_models/guardian_type.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';

class FirebaseDatabaseGuardiansRepository extends FirebaseDatabaseService {
  Stream<bool> hasGuardianNotificationPending(String userAccount) {
    bool _findNotification(QuerySnapshot event) {
      final QueryDocumentSnapshot? guardianNotification = event.docs.firstWhereOrNull(
        (QueryDocumentSnapshot? element) => element?.id == GUARDIAN_NOTIFICATION_KEY,
      );

      if (guardianNotification == null) {
        return false;
      } else {
        return guardianNotification[GUARDIAN_NOTIFICATION_KEY] as bool;
      }
    }

    return usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .snapshots()
        .map((event) => _findNotification(event));
  }

  Stream<List<GuardianModel>> getGuardiansForUser(String userId) {
    return usersCollection
        .doc(userId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .snapshots()
        .asyncMap((QuerySnapshot event) => event.docs.map(
            (QueryDocumentSnapshot e) => GuardianModel.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  Stream<bool> isGuardiansInitialized(String userAccount) {
    return usersCollection
        .doc(userAccount)
        .snapshots()
        // ignore: cast_nullable_to_non_nullable
        .map((user) => (user.data() as Map<String, dynamic>)[GUARDIAN_CONTRACT_INITIALIZED] as bool? ?? false);
  }

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  Future<Result<bool>> setGuardiansInitialized(String userAccount) {
    final data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: true,
      GUARDIAN_CONTRACT_INITIALIZED_DATE: FieldValue.serverTimestamp(),
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true)).then((value) {
      return ValueResult(true);
    }).catchError((onError) {
      // ignore: return_of_invalid_type_from_catch_error
      return ErrorResult(false);
    });
  }

  Future<Result<dynamic>> inviteGuardians(Set<ProfileModel> usersToInvite) {
    final currentUserId = settingsStorage.accountName;

    final batch = FirebaseFirestore.instance.batch();

    for (final guardian in usersToInvite) {
      final data = <String, Object>{
        UID_KEY: guardian.account,
        TYPE_KEY: GuardianType.myGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestSent.name,
        GUARDIANS_DATE_CREATED_KEY: FieldValue.serverTimestamp(),
        GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
      };

      final dataOther = <String, Object>{
        UID_KEY: currentUserId,
        TYPE_KEY: GuardianType.imGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestedMe.name,
        GUARDIANS_DATE_CREATED_KEY: FieldValue.serverTimestamp(),
        GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
      };

      final otherUserRef = usersCollection.doc(guardian.account);

      final currentUserRef = usersCollection
          .doc(currentUserId)
          .collection(GUARDIANS_COLLECTION_KEY)
          .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: guardian.account));

      final otherUserGuardianRef = otherUserRef
          .collection(GUARDIANS_COLLECTION_KEY)
          .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: guardian.account));

      // This empty is needed in case the user does not exist in the database yet. Create him.
      batch.set(otherUserRef, <String, dynamic>{}, SetOptions(merge: true));
      batch.set(currentUserRef, data, SetOptions(merge: true));
      batch.set(otherUserGuardianRef, dataOther, SetOptions(merge: true));
    }

    return batch.commit().then((value) {
      return ValueResult(value);
    }).catchError((onError) {
      // ignore: return_of_invalid_type_from_catch_error
      return ErrorResult(onError as Object);
    });
  }

  Future<void> cancelGuardianRequest({required String currentUserId, required String friendId}) {
    return _deleteMyGuardian(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> _deleteMyGuardian({required String currentUserId, required String friendId}) {
    final batch = FirebaseFirestore.instance.batch();

    final currentUserDocRef = usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: friendId));
    final otherUserDocRef = usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: friendId));

    batch.delete(currentUserDocRef);
    batch.delete(otherUserDocRef);

    return batch.commit();
  }

  Future<void> declineGuardianRequestedMe({required String currentUserId, required String friendId}) {
    return _deleteImGuardianFor(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> _deleteImGuardianFor({required String currentUserId, required String friendId}) {
    final batch = FirebaseFirestore.instance.batch();

    final currentUserDocRef = usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));
    final otherUserDocRef = usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    batch.delete(currentUserDocRef);
    batch.delete(otherUserDocRef);

    return batch.commit();
  }

  Future<void> acceptGuardianRequestedMe({required String currentUserId, required String friendId}) {
    final batch = FirebaseFirestore.instance.batch();

    final data = <String, Object>{
      GUARDIANS_STATUS_KEY: GuardianStatus.alreadyGuardian.name,
      GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
    };

    final currentUserDocRef = usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));
    final otherUserDocRef = usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    batch.set(currentUserDocRef, data, SetOptions(merge: true));
    batch.set(otherUserDocRef, data, SetOptions(merge: true));

    return batch.commit();
  }

  // This methods finds all the myGuardians for the {userId} and removes the RECOVERY_APPROVED_DATE_KEY for each one of them.
// Then it goes over to each user and removes the field from the users collection as well.
  Future<void> stopRecoveryForUser(String currentUserId) async {
    final data = <String, Object>{
      RECOVERY_STARTED_DATE_KEY: FieldValue.delete(),
      RECOVERY_APPROVED_DATE_KEY: FieldValue.delete(),
    };

    final batch = FirebaseFirestore.instance.batch();

    final myGuardians = await usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .get();

    for (final guardian in myGuardians.docs) {
      batch.set(
          usersCollection
              // ignore: cast_nullable_to_non_nullable
              .doc(GuardianModel.fromMap(guardian.data()).uid)
              .collection(GUARDIANS_COLLECTION_KEY)
              .doc(guardian.id),
          data,
          SetOptions(merge: true));
      batch.set(guardian.reference, data, SetOptions(merge: true));
    }

    return batch.commit();
  }

  Future<void> removeMyGuardian({required String currentUserId, required String friendId}) {
    return _deleteMyGuardian(currentUserId: currentUserId, friendId: friendId);
  }

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  Future<void> setGuardiansInitializedUpdated(String userAccount) {
    final data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: true,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardiansInitialized(String userAccount) {
    final data = <String, Object?>{
      GUARDIAN_CONTRACT_INITIALIZED: false,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
      GUARDIAN_RECOVERY_STARTED_KEY: null,
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> setGuardianRecoveryStarted(String userAccount) {
    final data = <String, Object>{
      GUARDIAN_RECOVERY_STARTED_KEY: FieldValue.serverTimestamp(),
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardianRecoveryStarted(String userAccount) {
    final data = <String, Object?>{
      GUARDIAN_RECOVERY_STARTED_KEY: null,
    };
    return usersCollection.doc(userAccount).set(data, SetOptions(merge: true));
  }

  Future<void> removeGuardianNotification(String userAccount) {
    final data = <String, Object>{GUARDIAN_NOTIFICATION_KEY: false};

    return usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .doc(GUARDIAN_NOTIFICATION_KEY)
        .set(data, SetOptions(merge: true));
  }
}

// Manage guardian Ids
String _createGuardianId({required String currentUserId, required String otherUserId}) {
  return '$currentUserId-$otherUserId';
}

String _createImGuardianForId({required String currentUserId, required String otherUserId}) {
  return '$otherUserId-$currentUserId';
}
