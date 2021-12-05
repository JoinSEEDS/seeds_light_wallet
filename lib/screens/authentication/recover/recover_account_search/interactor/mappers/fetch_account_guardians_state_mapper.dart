import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/recover/recover.i18n.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';

class FetchAccountGuardiansStateMapper extends StateMapper {
  RecoverAccountState mapResultToState(RecoverAccountState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Guardians".i18n);
    } else {
      final accountGuardiansModel = result.asValue!.value as UserGuardiansModel;
      if (accountGuardiansModel.guardians.isEmpty) {
        return currentState.copyWith(
          pageState: PageState.success,
          isGuardianActive: false,
          errorMessage: 'Only accounts protected by guardians are accessible for recovery'.i18n,
        );
      } else {
        return currentState.copyWith(
          pageState: PageState.success,
          isGuardianActive: true,
          userGuardians: accountGuardiansModel.guardians,
        );
      }
    }
  }
}
