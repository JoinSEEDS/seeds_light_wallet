import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/v2/domain-shared/event_bus/events.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';
import 'package:seeds/v2/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';
import 'package:seeds/v2/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';

import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class SendTransactionMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(SendEnterDataPageState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final resultResponse = result.asValue!.value as SendTransactionResponse;
      final transactionId = resultResponse.transactionId.asValue!.value as String;
      final double parsedQuantity = currentState.quantity;

      final selectedFiat = settingsStorage.selectedFiatCurrency;
      final String fiatAmount = currentState.ratesState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted;

      eventBus.fire(TransactionSentEventBusEvent(resultResponse.transactionModel));

      if (areAllResultsSuccess(resultResponse.profiles)) {
        final toAccount = resultResponse.profiles[0].asValue!.value as ProfileModel;
        final fromAccount = resultResponse.profiles[1].asValue!.value as ProfileModel;

        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowTransactionSuccess(
              currency: "Seeds",
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
        final fromAccount = settingsStorage.accountName;
        final toAccount = currentState.sendTo.account;

        return currentState.copyWith(
          pageState: PageState.success,
          pageCommand: ShowTransactionSuccess.withoutServerUserData(
            currency: "Seeds",
            fromAccount: fromAccount,
            amount: parsedQuantity.toString(),
            toAccount: toAccount,
            transactionId: transactionId,
            fiatAmount: fiatAmount,
          ),
        );
      }
    }
  }
}
