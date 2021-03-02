import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ImportKeyStateMapper extends StateMapper {
  ImportKeyState mapResultsToState(ImportKeyState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error Loading Accounts");
    } else {
      if (results.isEmpty) {
        return currentState.copyWith(pageState: PageState.failure, errorMessage: "No accounts found");
      } else {
        List<ProfileModel> profiles = results.map((Result result) => result.asValue.value as ProfileModel).toList();

        return currentState.copyWith(pageState: PageState.success, accounts: profiles);
      }
    }
  }
}
