import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';

class SendTransactionMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(SendEnterDataPageState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError!.error.toString());
    } else {
      final resultResponse = result.asValue!.value as SendTransactionResponse;
      final pageCommand =
          SendTransactionStateMapper.transactionResultPageCommand(resultResponse, currentState.ratesState);
      if (resultResponse.isTransfer) {
        eventBus.fire(OnNewTransactionEventBus(resultResponse.transferTransactionModel));
      }
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: pageCommand,
      );
    }
  }
}
