import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/import_key/interactor/viewmodels/import_key_state.dart';
import 'package:seeds/v2/screens/profile/interactor/usecases/get_profile_use_case.dart';

class ImportKeyStateMapper extends StateMapper {
  ImportKeyState mapResultToState(ImportKeyState currentState, Result result) {
    if (result.isValue) {
      List<String> accounts = result.asValue.value;
      if (accounts == null || accounts.isEmpty) {
        return currentState.copyWith(pageState: PageState.failure, errorMessage: "No accounts found");
      } else {
        return currentState.copyWith(pageState: PageState.success, accounts: result.asValue.value);
      }
    } else {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Failed to load account");
    }
  }
}
