import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/authentication/import_key/import_key_errors.dart';
import 'package:seeds/screens/profile_screens/profile/components/switch_account_bottom_sheet/interactor/viewmodels/switch_account_bloc.dart';

class SetFoundPrivateKeyStateMapper extends StateMapper {
  SwitchAccountState mapResultToState(SwitchAccountState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.noPublicKeyFound);
    } else {
      ///-------GET PRIVATE KEY
      final String publicKey = result.asValue!.value;
      // Find the keys pair match the public key
      final Keys keys = currentState.keys.singleWhere((i) => i.publicKey == publicKey);
      // Set the private key of the match pair
      return currentState.copyWith(authDataModel: AuthDataModel.fromKeyAndNoWords(keys.privateKey));
    }
  }
}
