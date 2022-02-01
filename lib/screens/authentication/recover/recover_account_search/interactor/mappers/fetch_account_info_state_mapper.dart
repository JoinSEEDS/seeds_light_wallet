import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_search_bloc.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/recover_account_search_errors.dart';

class FetchAccountInfoStateMapper extends StateMapper {
  RecoverAccountSearchState mapResultToState(RecoverAccountSearchState currentState, Result userInfo, String userName) {
    if (userInfo.isError) {
      return currentState.copyWith(
          pageState: PageState.failure, errorMessage: RecoverAccountSearchError.unableToLoadAccount);
    } else {
      final accountInfo = userInfo.asValue?.value as ProfileModel?;

      if (accountInfo != null) {
        return currentState.copyWith(
          pageState: PageState.success,
          accountInfo: accountInfo,
          errorMessage: currentState.errorMessage,
        );
      } else {
        return currentState.copyWith(
            pageState: PageState.success, errorMessage: RecoverAccountSearchError.invalidAccount);
      }
    }
  }
}
