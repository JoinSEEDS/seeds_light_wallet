import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/recover/recover.i18n.dart';
import 'package:seeds/screens/authentication/recover/recover_account_search/interactor/viewmodels/recover_account_state.dart';

class FetchAccountInfoStateMapper extends StateMapper {
  RecoverAccountState mapResultToState(RecoverAccountState currentState, Result userInfo, String userName) {
    if (userInfo.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Account".i18n);
    } else {
      final accountInfo = userInfo.asValue?.value as MemberModel?;

      if (accountInfo != null) {
        return currentState.copyWith(
          pageState: PageState.success,
          accountInfo: accountInfo,
          errorMessage: currentState.errorMessage,
        );
      } else {
        return currentState.copyWith(pageState: PageState.success, errorMessage: 'Account is not valid'.i18n);
      }
    }
  }
}
