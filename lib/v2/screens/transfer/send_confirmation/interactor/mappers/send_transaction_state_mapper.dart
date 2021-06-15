import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/v2/screens/transfer/send_confirmation/interactor/viewmodels/send_transaction_response.dart';
import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class SendTransactionStateMapper extends StateMapper {
  SendConfirmationState mapResultToState(SendConfirmationState currentState, Result result, RatesState rateState) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      var resultResponse = result.asValue!.value as SendTransactionResponse;
      var transactionId = resultResponse.transactionId.asValue!.value as String;

      String quantity = currentState.data['quantity'].toString();
      var currency = quantity.split(' ')[0];
      double parsedQuantity = double.parse(quantity.split(' ')[0]);

      var selectedFiat = settingsStorage.selectedFiatCurrency;
      String fiatAmount = rateState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted;

      if (areAllResultsSuccess(resultResponse.profiles)) {
        var toAccount = resultResponse.profiles[0].asValue!.value as ProfileModel;
        var fromAccount = resultResponse.profiles[1].asValue!.value as ProfileModel;

        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowTransactionSuccess(
              currency: currency,
              toImage: toAccount.image,
              fromImage: fromAccount.image,
              amount: parsedQuantity.toString(),
              toName: toAccount.nickname,
              toAccount: toAccount.account,
              fromName: fromAccount.nickname,
              fromAccount: fromAccount.account,
              fiatAmount: fiatAmount,
              transactionId: transactionId),
        );
      } else {
        var fromAccount = currentState.data["from"];
        var toAccount = currentState.data["to"];

        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowTransactionSuccess.withoutServerUserData(
              currency: currency,
              fromAccount: fromAccount,
              amount: parsedQuantity.toString(),
              toAccount: toAccount,
              transactionId: transactionId,
              fiatAmount: fiatAmount),
        );
      }
    }
  }
}
