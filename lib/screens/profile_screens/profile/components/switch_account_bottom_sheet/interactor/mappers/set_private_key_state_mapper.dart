import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class SetFoundPrivateKeyStateMapper extends StateMapper {
  SwitchAccountState mapResultToState(SwitchAccountState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "No public key found");
    } else {
      ///-------GET PRIVATE KEY
      final String publicKey = result.asValue!.value;
      // Get index of that public key in the current public keys list
      final int privateKeyIndex = currentState.publicKeys.indexOf(publicKey);
      // Since the storage private keys and SwitchAccountState public keys are map 1:1
      // the index will be the same to get the target private key
      final String privateKey = settingsStorage.privateKeysList[privateKeyIndex];

      return currentState.copyWith(authDataModel: AuthDataModel.fromKeyAndNoWords(privateKey));
    }
  }
}
