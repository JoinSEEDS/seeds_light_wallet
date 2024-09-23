import 'package:seeds/components/msig_proposal_action.dart';
import 'package:seeds/crypto/dart_esr/dart_esr.dart' as esr;
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/local/models/eos_action.dart';
import 'package:seeds/domain-shared/event_bus/event_bus.dart';
import 'package:seeds/domain-shared/event_bus/events.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_transaction_response.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

class SendTransactionMapper extends StateMapper {
  SendEnterDataState mapResultToState({required SendEnterDataState currentState, required Result result,
    required bool shouldShowInAppReview, required String failureClass})  {
    if (result.isError) {
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: ShowFailedTransactionReason(
          title: 'Error Sending Transaction',
          details: '${result.asError!.error}'.userErrorMessage,
          failureClass: failureClass,
        ),
       );
    } else {
      final resultResponse = result.asValue!.value as SendTransactionResponse;

      final int currentDate = DateTime.now().millisecondsSinceEpoch;
      bool _shouldShowInAppReview = shouldShowInAppReview;

      if (settingsStorage.dateSinceRateAppPrompted != null && _shouldShowInAppReview) {
        final int millisecondsPerMoth = 24 * 60 * 60 * 1000 * 30;
        final dateUntilAppRateCanAsk = settingsStorage.dateSinceRateAppPrompted! + millisecondsPerMoth;
        _shouldShowInAppReview = currentDate > dateUntilAppRateCanAsk;
      }

      final pageCommand = SendTransactionStateMapper.transactionResultPageCommand(
        resultResponse,
        currentState.ratesState,
        _shouldShowInAppReview,
      );
      if (resultResponse.isTransfer) {
        eventBus.fire(OnNewTransactionEventBus(resultResponse.transferTransactionModel));
      }
      return currentState.copyWith(
        pageState: PageState.success,
        pageCommand: pageCommand,
        retryMsig: false,
      );
    }
  }
}
