import 'package:seeds/v2/datasource/remote/firebase/firebase_database_repository.dart';

class GuardiansNotificationRepository extends FirebaseDatabaseService {
  Stream<bool> hasGuardianNotification(String userAccount) {
    return super.hasGuardianNotificationPending(userAccount);
  }
}
