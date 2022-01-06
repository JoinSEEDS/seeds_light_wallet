import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/wallet/interactor/viewmodels/wallet_bloc.dart';

class UserAccountStateMapper extends StateMapper {
  WalletState mapResultToState(WalletState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Error Loading Page');
    } else {
      final ProfileModel? profile = result.asValue!.value;

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
