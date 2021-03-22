import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/models/firebase/firebase_user.dart';
import 'package:seeds/models/firebase/guardian.dart';
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

  Stream<FirebaseUser> getUserData(String accountName) {
    return _usersCollection
        .doc(accountName)
        .snapshots()
        .map((DocumentSnapshot userData) => FirebaseUser.fromMap(userData.data(), accountName));
  }

  Future<void> setFirebaseMessageToken(String userId) {
    // Users can have multiple tokens. Ex: Multiple devices.
    var tokens = <String>[PushNotificationService().token];
    var data = <String, Object>{
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayUnion(tokens),
    };

    return _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  Future<void> removeFirebaseMessageToken(String userId) {
    var tokens = <String>[PushNotificationService().token];
    var data = <String, Object>{
      FIREBASE_MESSAGE_TOKENS_KEY: FieldValue.arrayRemove(tokens),
    };

    return _usersCollection.doc(userId).set(data, SetOptions(merge: true));
  }

  // Manage guardian Ids
  String _createGuardianId({String currentUserId, String otherUserId}) {
    return currentUserId + '-' + otherUserId;
  }

  String _createImGuardianForId({String currentUserId, String otherUserId}) {
    return otherUserId + '-' + currentUserId;
  }

  // Getters
  Stream<QuerySnapshot> getAllUserGuardians(String uid) {
    return _usersCollection.doc(uid).collection(GUARDIANS_COLLECTION_KEY).snapshots();
  }

  Future<QuerySnapshot> getGuardiansCount(String uid) {
    return _usersCollection.doc(uid).collection(GUARDIANS_COLLECTION_KEY).get();
  }

  Stream<QuerySnapshot> getMyAlreadyApprovedGuardiansForUser(String uid) {
    return _usersCollection
        .doc(uid)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .where(GUARDIANS_STATUS_KEY, isEqualTo: GuardianStatus.alreadyGuardian.name)
        .snapshots();
  }

  Future<QuerySnapshot> getMyAlreadyApprovedGuardiansForUserFuture(String uid) {
    return _usersCollection
        .doc(uid)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .where(GUARDIANS_STATUS_KEY, isEqualTo: GuardianStatus.alreadyGuardian.name)
        .get();
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

  // Actions on My Guardians
  Future<void> sendGuardiansInvite(String currentUserId, List<MemberModel> usersToInvite) {
    var batch = FirebaseFirestore.instance.batch();

    usersToInvite.forEach((guardian) {
      var data = <String, Object>{
        UID_KEY: guardian.account,
        TYPE_KEY: GuardianType.myGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestSent.name,
        GUARDIANS_DATE_CREATED_KEY: FieldValue.serverTimestamp(),
        GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
      };

      var dataOther = <String, Object>{
        UID_KEY: currentUserId,
        TYPE_KEY: GuardianType.imGuardian.name,
        GUARDIANS_STATUS_KEY: GuardianStatus.requestedMe.name,
        GUARDIANS_DATE_CREATED_KEY: FieldValue.serverTimestamp(),
        GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
      };

      var otherUserRef = _usersCollection.doc(guardian.account);

      var currentUserRef = _usersCollection
          .doc(currentUserId)
          .collection(GUARDIANS_COLLECTION_KEY)
          .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: guardian.account));

      var otherUserGuardianRef = otherUserRef
          .collection(GUARDIANS_COLLECTION_KEY)
          .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: guardian.account));

      // This empty is needed in case the user does not exist in the database yet. Create him.
      batch.set(otherUserRef, {}, SetOptions(merge: true));
      batch.set(currentUserRef, data, SetOptions(merge: true));
      batch.set(otherUserGuardianRef, dataOther, SetOptions(merge: true));
    });

    return batch.commit();
  }

  Future<void> cancelGuardianRequest({String currentUserId, String friendId}) {
    return _deleteMyGuardian(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> removeMyGuardian({String currentUserId, String friendId}) {
    return _deleteMyGuardian(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> _deleteMyGuardian({String currentUserId, String friendId}) {
    var batch = FirebaseFirestore.instance.batch();

    var currentUserDocRef = _usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: friendId));
    var otherUserDocRef = _usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createGuardianId(currentUserId: currentUserId, otherUserId: friendId));

    batch.delete(currentUserDocRef);
    batch.delete(otherUserDocRef);

    return batch.commit();
  }

  // Actions on I am Guardian for
  Future<void> removeImGuardianFor({String currentUserId, String friendId}) {
    return _deleteImGuardianFor(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> declineGuardianRequestedMe({String currentUserId, String friendId}) {
    return _deleteImGuardianFor(currentUserId: currentUserId, friendId: friendId);
  }

  Future<void> acceptGuardianRequestedMe({String currentUserId, String friendId}) {
    var batch = FirebaseFirestore.instance.batch();

    var data = <String, Object>{
      GUARDIANS_STATUS_KEY: GuardianStatus.alreadyGuardian.name,
      GUARDIANS_DATE_UPDATED_KEY: FieldValue.serverTimestamp(),
    };

    var currentUserDocRef = _usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));
    var otherUserDocRef = _usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    batch.set(currentUserDocRef, data, SetOptions(merge: true));
    batch.set(otherUserDocRef, data, SetOptions(merge: true));

    return batch.commit();
  }

  Future<void> _deleteImGuardianFor({String currentUserId, String friendId}) {
    var batch = FirebaseFirestore.instance.batch();

    var currentUserDocRef = _usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));
    var otherUserDocRef = _usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    batch.delete(currentUserDocRef);
    batch.delete(otherUserDocRef);

    return batch.commit();
  }

  Future<void> approveRecoveryForUser({String currentUserId, String friendId}) async {
    var batch = FirebaseFirestore.instance.batch();

    var data = <String, Object>{
      RECOVERY_APPROVED_DATE_KEY: FieldValue.serverTimestamp(),
    };

    var currentUserDocRef = _usersCollection
        .doc(currentUserId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    var otherUserDocRef = _usersCollection
        .doc(friendId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .doc(_createImGuardianForId(currentUserId: currentUserId, otherUserId: friendId));

    batch.set(currentUserDocRef, data, SetOptions(merge: true));
    batch.set(otherUserDocRef, data, SetOptions(merge: true));

    return batch.commit();
  }

  // This methods finds all the myGuardians for the {userId} and add the RECOVERY_APPROVED_DATE_KEY for each one of them.
  // Then it goes over to each user and adds the field from the users collection as well.
  Future<void> startRecoveryForUser({String currentUserId, String userId}) async {
    var batch = FirebaseFirestore.instance.batch();

    var myGuardians = await _usersCollection
        .doc(userId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .get();

    myGuardians.docs.forEach((QueryDocumentSnapshot guardian) {
      var data = <String, Object>{
        RECOVERY_STARTED_DATE_KEY: FieldValue.serverTimestamp(),
      };

      if (Guardian.fromMap(guardian.data()).uid == currentUserId) {
        data.addAll({RECOVERY_APPROVED_DATE_KEY: FieldValue.serverTimestamp()});
      }

      batch.set(
          _usersCollection
              .doc(Guardian.fromMap(guardian.data()).uid)
              .collection(GUARDIANS_COLLECTION_KEY)
              .doc(guardian.id),
          data,
          SetOptions(merge: true));
      batch.set(guardian.reference, data, SetOptions(merge: true));
    });
    return batch.commit();
  }

  // This methods finds all the myGuardians for the {userId} and removes the RECOVERY_APPROVED_DATE_KEY for each one of them.
  // Then it goes over to each user and removes the field from the users collection as well.
  Future<void> stopRecoveryForUser({String userId}) async {
    var data = <String, Object>{
      RECOVERY_STARTED_DATE_KEY: FieldValue.delete(),
      RECOVERY_APPROVED_DATE_KEY: FieldValue.delete(),
    };

    var batch = FirebaseFirestore.instance.batch();

    var myGuardians = await _usersCollection
        .doc(userId)
        .collection(GUARDIANS_COLLECTION_KEY)
        .where(TYPE_KEY, isEqualTo: GuardianType.myGuardian.name)
        .get();

    myGuardians.docs.forEach((QueryDocumentSnapshot guardian) {
      batch.set(
          _usersCollection
              .doc(Guardian.fromMap(guardian.data()).uid)
              .collection(GUARDIANS_COLLECTION_KEY)
              .doc(guardian.id),
          data,
          SetOptions(merge: true));
      batch.set(guardian.reference, data, SetOptions(merge: true));
    });
    return batch.commit();
  }

  Future<DocumentReference> createProduct(ProductModel product, String userAccount) {
    var data = <String, Object>{
      PRODUCT_NAME_KEY: product.name,
      PRODUCT_PRICE_KEY: product.price,
      PRODUCT_CREATED_DATE_KEY: FieldValue.serverTimestamp(),
      PRODUCT_CURRENCY_KEY: product.currency,
      PRODUCT_POSITION_KEY: product.position,
    };

    if (product.picture != null && product.picture.isNotEmpty) {
      data.addAll({PRODUCT_IMAGE_URL_KEY: product.picture});
    }

    return _usersCollection.doc(userAccount).collection(PRODUCTS_COLLECTION_KEY).add(data);
  }

  Future<void> updateProduct(ProductModel product, String userAccount) {
    var data = <String, Object>{
      PRODUCT_NAME_KEY: product.name,
      PRODUCT_PRICE_KEY: product.price,
      PRODUCT_CURRENCY_KEY: product.currency,
      PRODUCT_UPDATED_DATE_KEY: FieldValue.serverTimestamp(),
    };

    if (product.picture != null && product.picture.isNotEmpty) {
      data.addAll({PRODUCT_IMAGE_URL_KEY: product.picture});
    }

    return _usersCollection
        .doc(userAccount)
        .collection(PRODUCTS_COLLECTION_KEY)
        .doc(product.id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> deleteProduct(ProductModel product, String userAccount) {
    return _usersCollection.doc(userAccount).collection(PRODUCTS_COLLECTION_KEY).doc(product.id).delete();
  }

  Stream<QuerySnapshot> getOrderedProductsForUser(String accountName) {
    return _usersCollection
        .doc(accountName)
        .collection(PRODUCTS_COLLECTION_KEY)
        .orderBy(PRODUCT_POSITION_KEY, descending: false)
        .snapshots();
  }

  Stream<List<ProductModel>> getProductsForUser(String accountName) {
    return _usersCollection
        .doc(accountName)
        .collection(PRODUCTS_COLLECTION_KEY)
        .orderBy(PRODUCT_CREATED_DATE_KEY)
        .snapshots()
        .asyncMap((event) => event.docs.map((QueryDocumentSnapshot data) => ProductModel.fromSnapshot(data)).toList());
  }

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  Future<void> setGuardiansInitialized(String userAccount) {
    var data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: true,
      GUARDIAN_CONTRACT_INITIALIZED_DATE: FieldValue.serverTimestamp(),
    };
    return _usersCollection.doc(userAccount).set(data, SetOptions(merge: false));
  }

  /// Use only when we have successfully saved guardians to the user contract by calling eosService.initGuardians
  Future<void> setGuardiansInitializedUpdated(String userAccount) {
    var data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: true,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
    };
    return _usersCollection.doc(userAccount).set(data, SetOptions(merge: false));
  }

  Future<void> removeGuardiansInitialized(String userAccount) {
    var data = <String, Object>{
      GUARDIAN_CONTRACT_INITIALIZED: false,
      GUARDIAN_CONTRACT_INITIALIZED_UPDATE_DATE: FieldValue.serverTimestamp(),
      GUARDIAN_RECOVERY_STARTED_KEY: null,
    };
    return _usersCollection.doc(userAccount).set(data, SetOptions(merge: false));
  }

  Stream<bool> isGuardiansInitialized(String userAccount) {
    return _usersCollection
        .doc(userAccount)
        .snapshots()
        .map((user) => user.data()[GUARDIAN_CONTRACT_INITIALIZED] ?? false);
  }

  Stream<bool> hasGuardianNotificationPending(String userAccount) {
    bool _findNotification(QuerySnapshot event) {
      var guardianNotification =
          event.docs.firstWhere((QueryDocumentSnapshot element) => element.id == GUARDIAN_NOTIFICATION_KEY, orElse: () {
        return null;
      });

      if (guardianNotification == null) {
        return false;
      } else {
        return guardianNotification[GUARDIAN_NOTIFICATION_KEY];
      }
    }

    return _usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .snapshots()
        .map((event) => _findNotification(event));
  }

  Future<void> removeGuardianNotification(String userAccount) {
    var data = <String, Object>{GUARDIAN_NOTIFICATION_KEY: false};

    return _usersCollection
        .doc(userAccount)
        .collection(PENDING_NOTIFICATIONS_KEY)
        .doc(GUARDIAN_NOTIFICATION_KEY)
        .set(data);
  }

  Future<void> setGuardianRecoveryStarted(String userAccount) {
    var data = <String, Object>{
      GUARDIAN_RECOVERY_STARTED_KEY: FieldValue.serverTimestamp(),
    };
    return _usersCollection.doc(userAccount).set(data, SetOptions(merge: false));
  }
}
