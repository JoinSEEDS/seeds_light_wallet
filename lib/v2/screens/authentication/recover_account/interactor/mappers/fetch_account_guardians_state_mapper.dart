import 'package:seeds/v2/datasource/remote/model/account_recovery_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/import_key/import_key.i18n.dart';
import 'package:seeds/v2/screens/authentication/recover_account/interactor/viewmodels/recover_account_state.dart';

class FetchAccountRecoveryStateMapper extends StateMapper {
  RecoverAccountState mapResultToState(RecoverAccountState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Guardians".i18n);
    } else {
      var accountGuardiansModel = result.asValue!.value as AccountRecoveryModel;
      if (accountGuardiansModel.guardians.isEmpty) {
        return currentState.copyWith(
            pageState: PageState.success,
            isValidUsername: false,
            errorMessage: 'Only accounts protected by guardians are accessible for recovery');
      } else {
        return currentState.copyWith(pageState: PageState.success, isValidUsername: true, errorMessage: null);
      }
    }
  }
}
