import 'package:collection/collection.dart';
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
      ///-------GET PRIVATE KEY MATCHING ONE OF THE PUBLIC KEYS
      for(final String publicKey in result.asValue!.value as List<String>) {
        // Find the keys pair match the public key
        final Keys? keypair = currentState.keys.singleWhereOrNull((i) =>
        i.publicKey == publicKey);
        if(keypair != null) {
          // Set the private key of the match pair
          return currentState.copyWith(
              authDataModel: AuthDataModel.fromKeyAndNoWords(
                  keypair.privateKey));
        }
      }
      return currentState.copyWith(pageState: PageState.failure, error: ImportKeyError.noPublicKeyFound);
    }
  }
}
