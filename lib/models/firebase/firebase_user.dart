import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';

class FirebaseUser {
  final String account;
  final Timestamp guardianRecoveryStarted;
  final String phoneNumber;

  FirebaseUser({this.account, this.guardianRecoveryStarted, this.phoneNumber});

  FirebaseUser.fromMap(Map<String, dynamic> data, String accountName)
      : this(
            account: accountName,
            guardianRecoveryStarted: data[GUARDIAN_RECOVERY_STARTED_KEY],
            phoneNumber: data[USER_PHONE_NUMBER_KEY]);
}
