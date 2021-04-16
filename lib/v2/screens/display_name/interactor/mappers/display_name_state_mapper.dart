import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/display_name/interactor/viewmodels/display_name_state.dart';

class DisplayNameMapper extends StateMapper {
  DisplayNameState mapResultsToState(DisplayNameState currentState, List<Result> results, String privateKey) {
    // No account found. Show error
    if (results.isEmpty) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "No accounts found");
    }

    // Accounts found, but errors fetching data happened.
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts");
    } else {
      List<ProfileModel> profiles = results.map((Result result) => result.asValue.value as ProfileModel).toList();

      return currentState.copyWith(pageState: PageState.success, accounts: profiles, privateKey: privateKey);
    }
  }
}
