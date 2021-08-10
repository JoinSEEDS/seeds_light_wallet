import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_status.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';

class GuardianModel {
  final String uid;
  final GuardianStatus status;
  final GuardianType type;
  final Timestamp dateCreated;
  final Timestamp? lastUpdated;
  final Timestamp? recoveryStartedDate;
  final Timestamp? recoveryApprovedDate;
  final String? nickname;
  final String? image;

  GuardianModel({
    required this.uid,
    required this.status,
    required this.type,
    required this.dateCreated,
    this.lastUpdated,
    this.recoveryStartedDate,
    this.recoveryApprovedDate,
    this.nickname,
    this.image,
  });

  GuardianModel.fromMap(Map<String, dynamic> data)
      : this(
          uid: data[UID_KEY],
          status: fromStatusName(data[GUARDIANS_STATUS_KEY]),
          type: fromTypeName(data[TYPE_KEY]),
          dateCreated: data[GUARDIANS_DATE_CREATED_KEY],
          lastUpdated: data[GUARDIANS_DATE_UPDATED_KEY],
          recoveryStartedDate: data[RECOVERY_STARTED_DATE_KEY],
          recoveryApprovedDate: data[RECOVERY_APPROVED_DATE_KEY],
        );

  GuardianModel copyWith({
    String? uid,
    GuardianStatus? status,
    GuardianType? type,
    Timestamp? dateCreated,
    Timestamp? lastUpdated,
    Timestamp? recoveryStartedDate,
    Timestamp? recoveryApprovedDate,
    String? nickname,
    String? image,
  }) {
    return GuardianModel(
      uid: uid ?? this.uid,
      status: status ?? this.status,
      type: type ?? this.type,
      dateCreated: dateCreated ?? this.dateCreated,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      recoveryStartedDate: recoveryStartedDate ?? this.recoveryStartedDate,
      recoveryApprovedDate: recoveryApprovedDate ?? this.recoveryApprovedDate,
      nickname: nickname ?? this.nickname,
      image: image ?? this.image,
    );
  }
}
