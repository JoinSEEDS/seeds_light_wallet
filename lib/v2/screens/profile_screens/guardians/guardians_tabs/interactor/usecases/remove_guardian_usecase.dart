import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
import 'package:async/async.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_model.dart';
import 'package:seeds/v2/datasource/remote/model/firebase_models/guardian_type.dart';

class RemoveGuardianUseCase {
  final FirebaseDatabaseGuardiansRepository _firebaseRepository = FirebaseDatabaseGuardiansRepository();
  final GuardiansRepository _guardiansRepository = GuardiansRepository();

  Future<Result<dynamic>> removeGuardian(GuardianModel guardian) {
    return _guardiansRepository.cancelGuardians().then((Result value) {
      if (value.isError) {
        // cancelGuardians fails if the user does not have guardians.
        // We dont want to fail, our purpose is to remove guardians, and if the user doesnt have guardians
        // then we succeeded. Thats why we return ValueResult if it fails with "does not have guards"
        if(value.asError!.error.toString().contains('does not have guards')) {
          return _onCancelGuardiansSuccess(guardian.uid);
        } else {
          return value;
        }
      } else {
        return _onCancelGuardiansSuccess(guardian.uid);
      }
    });
  }

  Future<Result> _onCancelGuardiansSuccess(String friendId) async {
    var accountName = settingsStorage.accountName;

    List<GuardianModel> guardiansQuery = await _firebaseRepository
        .getGuardiansForUser(accountName)
        .first;
    print('cancelResult success');
    guardiansQuery.retainWhere((GuardianModel element) => element.type == GuardianType.myGuardian);

    if (guardiansQuery.length > 3) {
      print('guardiansQuery.docs.length IS > 3');
      var guardians = guardiansQuery.map((e) => e.uid).toList();
      return await _guardiansRepository.initGuardians(guardians).then((value) {
        if(value.isError) {
          return value;
        } else {
          return _removeGuardianFromFirebase(accountName, friendId);
        }
      } ).catchError((onError) => ErrorResult(false));
    } else {
      print('guardiansQuery.docs.length IS NOT > 3');
      // Case where user does not have enough guardians
      return _removeGuardianFromFirebase(accountName, friendId);
    }
  }

  ValueResult<bool> _removeGuardianFromFirebase(String userAccount, String friendId) {
    print('initResult success');
    _firebaseRepository.removeMyGuardian(currentUserId: userAccount, friendId: friendId);
    _firebaseRepository.setGuardiansInitializedUpdated(userAccount);

    return ValueResult(true);
  }
}