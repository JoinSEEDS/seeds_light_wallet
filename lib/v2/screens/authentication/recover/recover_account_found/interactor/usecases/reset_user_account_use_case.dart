import 'package:async/async.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:seeds/v2/datasource/remote/api/guardians_repository.dart';
import 'package:seeds/v2/datasource/remote/api/members_repository.dart';
import 'package:seeds/v2/datasource/remote/firebase/firebase_database_guardians_repository.dart';
import 'package:seeds/v2/domain-shared/app_constants.dart';
import 'package:seeds/v2/domain-shared/shared_use_cases/cerate_firebase_dynamic_link_use_case.dart';

class ResetUserAccountUseCase {
  final GuardiansRepository _guardiansRepository = GuardiansRepository();
  final FirebaseDatabaseGuardiansRepository _firebaseDatabaseGuardiansRepository = FirebaseDatabaseGuardiansRepository();

  Future<Result> run(String userAccount) async {
   var result =  await _guardiansRepository.claimRecoveredAccount(userAccount);

   if(result.isValue) {
     await _firebaseDatabaseGuardiansRepository.removeGuardianRecoveryStarted(userAccount);
   }

   return result;
  }
}