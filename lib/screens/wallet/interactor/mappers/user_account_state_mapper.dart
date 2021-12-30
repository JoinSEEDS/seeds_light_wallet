import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class UserAccountStateMapper extends StateMapper {
  WalletState mapResultToState(WalletState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      results.retainWhere((Result i) => i.isValue);
      final values = results.map((Result i) => i.asValue!.value).toList();
      final ProfileModel? profile = values.firstWhere((i) => i is ProfileModel, orElse: () => null);

      if (profile != null && profile.status == ProfileStatus.citizen) {
        // Here is the first time the get user profile is called in the app
        // so we need save here the is citizen status in the settingsStorage
        // to avoid show shimmer again in the citizenship module
        settingsStorage.saveIsCitizen(true);
      }

      return currentState.copyWith(pageState: PageState.success, profile: profile);
    }
  }
}
