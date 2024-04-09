import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/firebase/firebase_database_repository.dart';

class FirebaseUserModel extends Equatable {
  final String account;
  final Timestamp? guardianRecoveryStarted;

  const FirebaseUserModel({required this.account, this.guardianRecoveryStarted});

  factory FirebaseUserModel.fromDocument(Map<String, dynamic> document, String account) {
    return FirebaseUserModel(
      guardianRecoveryStarted: document[GUARDIAN_RECOVERY_STARTED_KEY] as Timestamp,
      account: account,
    );
  }

  @override
  List<Object?> get props => [account, guardianRecoveryStarted];
}
