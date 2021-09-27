import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/i18n/authentication/import_key/import_key.i18n.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class FindAccountsResultStateMapper extends StateMapper {
  SwitchAccountState mapResultsToState(SwitchAccountState currentState, List<Result> results) {
    // No account found. Show error
    if (results.isEmpty) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "No accounts found".i18n);
    }

    // Accounts found, but errors fetching data happened.
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts".i18n);
    } else {
      final List<ProfileModel> profiles = results
          .where((Result result) => result.isValue)
          .map((Result result) => result.asValue!.value as ProfileModel)
          .toList();

      return currentState.copyWith(pageState: PageState.success, accounts: profiles, currentAcccout: profiles.first);
    }
  }
}
