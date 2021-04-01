import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/profile/interactor/usecases/get_profile_use_case.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';

class SendTransactionStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: result.asError.error.toString());
    } else {
      var resultResponse = result.asValue.value as SendTransactionResponse;
      var transactionId = resultResponse.transactionId.asValue.value as String;

      var areAllProfilesSuccess = areAllResultsSuccess(resultResponse.profiles);
      var quantity = currentState.data["quantity"];

      if (areAllProfilesSuccess) {
        var toAccount = resultResponse.profiles[0].asValue.value as ProfileModel;
        var fromAccount = resultResponse.profiles[1].asValue.value as ProfileModel;

        return currentState.copyWith(
            pageState: PageState.success,
            pageCommand: ShowTransactionSuccess(
                toImage: toAccount.image,
                fromImage: fromAccount.image,
                amount: quantity,
                toName: toAccount.nickname,
                toAccount: toAccount.account,
                fromName: fromAccount.nickname,
                fromAccount: fromAccount.account,
                transactionId: transactionId));
      } else {
        var fromAccount = currentState.data["from"];
        var toAccount = currentState.data["to"];

        GERY HERE!!
        var selectedFiat = settingsStorage.selectedFiatCurrency;

        return currentState.copyWith(
            pageState: PageState.success,
            pageCommand: ShowTransactionSuccess.withoutServerUserData(
                fromAccount: fromAccount, amount: quantity, toAccount: toAccount, transactionId: transactionId));
      }
    }
  }
}
