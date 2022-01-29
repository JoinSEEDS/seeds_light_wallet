import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/import_key_errors.dart';
import 'package:seeds/screens/authentication/import_key/interactor/viewmodels/import_key_bloc.dart';

class ImportKeyStateMapper extends StateMapper {
  ImportKeyState mapResultsToState({
    required ImportKeyState currentState,
    required AuthDataModel authData,
    required List<Result> results,
    AuthDataModel? alternateAuthData,
    List<Result> alternateResults = const [],
  }) {
    final List<Result> goodResults = results.isNotEmpty ? results : alternateResults;
    final AuthDataModel? goodAuthData = results.isNotEmpty ? authData : alternateAuthData;
    // No account found. Show error
    if (goodResults.isEmpty) {
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.noAccountsFound);
    }

    // Accounts found, but errors fetching data happened.
    if (areAllResultsError(goodResults)) {
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.unableToLoadAccount);
    } else {
      final List<ProfileModel> profiles = goodResults
          .where((Result result) => result.isValue)
          .map((Result result) => result.asValue!.value as ProfileModel)
          .toList();

      return currentState.copyWith(pageState: PageState.success, accounts: profiles, authData: goodAuthData);
    }
  }
}
