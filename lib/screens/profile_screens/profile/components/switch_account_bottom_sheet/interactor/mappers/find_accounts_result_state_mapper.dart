import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/import_key_errors.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class FindAccountsResultStateMapper extends StateMapper {
  SwitchAccountState mapResultsToState(SwitchAccountState currentState, List<Result> results, List<Keys> keys) {
    // No account found. Show error
    if (results.isEmpty) {
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.noAccountsFound);
    }

    // Accounts found, but errors fetching data happened.
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.unableToLoadAccount);
    } else {
      final List<ProfileModel> profiles = results
          .where((Result result) => result.isValue)
          .map((Result result) => result.asValue!.value as ProfileModel)
          .toList();

      final currentAccount =
          profiles.singleWhere((i) => i.account == settingsStorage.accountName, orElse: () => profiles.first);
      profiles.remove(currentAccount);
      profiles.insert(0, currentAccount);

      return currentState.copyWith(
        pageState: PageState.success,
        accounts: profiles,
        keys: keys,
        currentAcccout: currentAccount,
      );
    }
  }
}
