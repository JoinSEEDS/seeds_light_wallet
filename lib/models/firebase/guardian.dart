// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/models/firebase/guardian_status.dart';
import 'package:seeds/models/firebase/guardian_type.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';

class Guardian {
  final String uid;
  final GuardianStatus status;
  final GuardianType type;
  final Timestamp dateCreated;
  final Timestamp lastUpdated;
  final Timestamp recoveryStartedDate;
  final Timestamp recoveryApprovedDate;

  Guardian.fromMap(Map<String, dynamic> data)
      : this(
          uid: data[UID_KEY],
          status: fromStatusName(data[GUARDIANS_STATUS_KEY]),
          type: fromTypeName(data[TYPE_KEY]),
          dateCreated: data[GUARDIANS_DATE_CREATED_KEY],
          lastUpdated: data[GUARDIANS_DATE_UPDATED_KEY],
          recoveryStartedDate: data[RECOVERY_STARTED_DATE_KEY],
          recoveryApprovedDate: data[RECOVERY_APPROVED_DATE_KEY],
        );

  Guardian(
      {this.uid,
      this.status,
      this.type,
      this.dateCreated,
      this.lastUpdated,
      this.recoveryStartedDate,
      this.recoveryApprovedDate});
}
