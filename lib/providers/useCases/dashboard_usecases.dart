import 'package:seeds/models/firebase/firebase_user.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';

class DashboardUseCases {
  Stream<bool> shouldShowCancelGuardianAlertMessage(String accountName) {
    bool _shouldShowDialog(FirebaseUser firebaseUser) {
      return firebaseUser.guardianRecoveryStarted != null;
    }

    return FirebaseDatabaseService()
        .getUserData(accountName)
        .map((FirebaseUser userData) => _shouldShowDialog(userData));
  }
}
