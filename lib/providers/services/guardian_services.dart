import 'package:seeds/providers/services/eos_service.dart';
import 'package:seeds/providers/services/firebase/firebase_database_map_keys.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';

class GuardianServices {
  GuardianServices._();

  factory GuardianServices() => _instance;

  static final GuardianServices _instance = GuardianServices._();

  /// First Time Ever setting guardians.
  Future initGuardians(EosService eosService, String userAccount) async {
    var guardiansQuery = await FirebaseDatabaseService().getMyGuardians(userAccount).first;

    if (guardiansQuery.docs.length >= 3) {
      var guardians = guardiansQuery.docs.map((e) => e[UID_KEY].toString()).toList();
      print(guardians[0].toString());

      print('guardiansQuery.docs.length >= 3 is true');
      return await eosService.setGuardianPermission().then((value) => eosService
          .initGuardians(guardians)
          .then((value) => FirebaseDatabaseService().setGuardiansInitialized(userAccount)));
    }
  }

  /// User wants to remove one of his guardians.
  Future removeGuardian(EosService eosService, String userAccount, String friendId) async {
    print('removeGuardian started');
    return eosService
        .cancelGuardiansSafe()
        .then((value) => _onCancelGuardiansSuccess(eosService, userAccount, friendId));
  }

  /// User wants to stop a hack recovery attempt
  Future stopActiveRecovery(EosService eosService, String userAccount) async {
    print('cancelActiveRecovery started');
    return eosService.cancelGuardiansSafe().then((value) => _onStopRecoverySuccess(eosService, userAccount));
  }

  Future<void> _onStopRecoverySuccess(EosService eosService, String userAccount) async {
    print('_onStopRecoverySuccess');
    return await FirebaseDatabaseService().removeGuardiansInitialized(userAccount);
  }

  Future<void> _onCancelGuardiansSuccess(EosService eosService, String userAccount, String friendId) async {
    var guardiansQuery = await FirebaseDatabaseService().getMyGuardians(userAccount).first;
    print('cancelResult success');

    if (guardiansQuery.docs.length > 3) {
      print('guardiansQuery.docs.length IS > 3');
      var guardians = guardiansQuery.docs.map((e) => e[UID_KEY]).toList();
      return await eosService.initGuardians(guardians).then((value) => _onInitGuardiansSuccess(userAccount, friendId));
    } else {
      print('guardiansQuery.docs.length IS NOT > 3');
      // Case where user does not have enough guardians
      await FirebaseDatabaseService().removeMyGuardian(currentUserId: userAccount, friendId: friendId);
      return await FirebaseDatabaseService().removeGuardiansInitialized(userAccount);
    }
  }

  // ignore: always_declare_return_types
  _onInitGuardiansSuccess(String userAccount, String friendId) {
    print('initResult success');
    FirebaseDatabaseService().removeMyGuardian(currentUserId: userAccount, friendId: friendId);
    FirebaseDatabaseService().setGuardiansInitializedUpdated(userAccount);
  }
}
