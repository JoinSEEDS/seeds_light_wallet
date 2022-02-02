import 'package:seeds/datasource/remote/model/account_guardians_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_search_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_search_errors.dart';

class FetchAccountGuardiansStateMapper extends StateMapper {
  RecoverAccountSearchState mapResultToState(RecoverAccountSearchState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(
          pageState: PageState.failure, errorMessage: RecoverAccountSearchError.unableToLoadGuardians);
    } else {
      final accountGuardiansModel = result.asValue!.value as UserGuardiansModel;
      if (accountGuardiansModel.guardians.isEmpty) {
        return currentState.copyWith(
          pageState: PageState.success,
          isGuardianActive: false,
          errorMessage: RecoverAccountSearchError.noActiveGuardians,
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
