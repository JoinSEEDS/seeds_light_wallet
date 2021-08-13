import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/i18n/import_key/import_key.i18n.dart';
import 'package:seeds/v2/screens/authentication/import_key/interactor/viewmodels/import_key_state.dart';

class ImportKeyStateMapper extends StateMapper {
  ImportKeyState mapResultsToState(ImportKeyState currentState, List<Result> results, String privateKey) {
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

      return currentState.copyWith(pageState: PageState.success, accounts: profiles, privateKey: privateKey);
    }
  }
}
