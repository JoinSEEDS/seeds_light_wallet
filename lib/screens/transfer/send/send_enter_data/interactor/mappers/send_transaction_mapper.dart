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
  SendEnterDataState mapResultToState(SendEnterDataState currentState, Result result, bool shouldShowInAppReview) {
    String failureClass = '';
    if (result.isError) {
      if ((result.asError!.error as String).contains('missing_auth_exception')
        || (result.asError!.error as String).contains('unsatisfied_authorization')) {
        // we want to check whether auth acct for first action has signers  
        // however this takes an async chain lookup     
        /*
        final transaction = SendEnterDataBloc.buildTransferTransaction(currentState);
        final auth = transaction.actions?[0]?.authorization?.map((e) => 
                          esr.Authorization() ..actor = e?.actor ..permission = e?.permission ).toList()?[0];
        if (auth != null && MsigProposal.signingAccounts(auth: auth!) != null) {
        */
          failureClass = "canMsig";
        //}
      }
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
