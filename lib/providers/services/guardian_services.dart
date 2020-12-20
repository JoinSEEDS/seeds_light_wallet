import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';

class GuardianServices {
  GuardianServices._();

  factory GuardianServices() => _instance;

  static final GuardianServices _instance = GuardianServices._();

  /// First Time Ever setting guardians.
  Future initGuardians(EosService eosService, String userAccount) async {
    QuerySnapshot guardiansQuery = await FirebaseDatabaseService().getMyGuardians(userAccount).first;

    if (guardiansQuery.docs.length >= 3) {
      var guardians = guardiansQuery.docs.map((e) => e[UID_KEY].toString()).toList();
      print(guardians[0].toString());

      print("guardiansQuery.docs.length >= 3 is true");
      return await eosService.setGuardianPermission().then((value) => eosService
          .initGuardians(guardians)
          .then((value) => FirebaseDatabaseService().setGuardiansInitialized(userAccount)));
    }
  }

  /// User wants to remove one of his guardians.
  removeGuardian(EosService eosService, String userAccount, String friendId) async {
    print("removeGuardian started");
    QuerySnapshot guardiansQuery = await FirebaseDatabaseService().getMyGuardians(userAccount).first;
    var cancelResult = await eosService.cancelGuardians();

    // Cancel success
    if (_isTransactionSuccess(cancelResult)) {
      print("cancelResult success");
      if (guardiansQuery.docs.length > 3) {
        print("guardiansQuery.docs.length IS > 3");
        var guardians = guardiansQuery.docs.map((e) => e[UID_KEY]).toList();
        var initResult = await eosService.initGuardians(guardians);

        // Init success
        if (_isTransactionSuccess(initResult)) {
          print("initResult success");
          FirebaseDatabaseService().removeMyGuardian(currentUserId: userAccount, friendId: friendId);
          FirebaseDatabaseService().setGuardiansInitializedUpdated(userAccount);
        }
      } else {
        print("guardiansQuery.docs.length IS NOT > 3");
        // Case where user does not have enough guardians
        FirebaseDatabaseService().removeMyGuardian(currentUserId: userAccount, friendId: friendId);
        FirebaseDatabaseService().removeGuardiansInitialized(userAccount);
      }
    }
  }

  _isTransactionSuccess(dynamic result) {
    return result != null && result["transaction_id"] != null;
  }
}
