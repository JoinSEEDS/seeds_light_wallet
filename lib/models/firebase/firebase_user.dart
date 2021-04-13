// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';

class FirebaseUser {
  final String account;
  final Timestamp guardianRecoveryStarted;

  FirebaseUser({this.account, this.guardianRecoveryStarted});

  FirebaseUser.fromMap(Map<String, dynamic> data, String accountName)
      : this(account: accountName, guardianRecoveryStarted: data[GUARDIAN_RECOVERY_STARTED_KEY]);
}
