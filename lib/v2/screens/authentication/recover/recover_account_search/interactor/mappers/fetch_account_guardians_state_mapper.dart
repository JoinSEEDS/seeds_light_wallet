import 'package:seeds/v2/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/import_key/import_key.i18n.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';

class FetchAccountRecoveryStateMapper extends StateMapper {
  RecoverAccountState mapResultToState(RecoverAccountState currentState, Result result, String userName) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Guardians".i18n);
    } else {
      var accountGuardiansModel = result.asValue!.value as UserGuardiansModel;
      if (accountGuardiansModel.guardians.isEmpty) {
        return currentState.copyWith(
            pageState: PageState.success,
            isGuardianActive: false,
            errorMessage: 'Only accounts protected by guardians are accessible for recovery');
      } else {
        return currentState.copyWith(
          isValidAccount: false,
          pageState: PageState.success,
          isGuardianActive: true,
          userGuardians: accountGuardiansModel.guardians,
          userName: userName,
        );
      }
    }
  }
}
