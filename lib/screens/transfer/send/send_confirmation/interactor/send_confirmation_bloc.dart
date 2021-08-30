import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_info_line_items.dart';
import 'package:seeds/utils/cap_utils.dart';

/// --- BLOC
class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc(arguments) : super(SendConfirmationState.initial(arguments));

  @override
  Stream<SendConfirmationState> mapEventToState(SendConfirmationEvent event) async* {
    if (event is InitSendConfirmationWithArguments) {
      yield state.copyWith(
          pageState: PageState.success,
          lineItems:
              state.data.entries.map((e) => SendInfoLineItems(label: e.key.inCaps, text: e.value.toString())).toList(),
          actionName: state.actionName,
          account: state.account,
          data: state.data);
    } else if (event is SendTransactionEvent) {
      yield state.copyWith(pageState: PageState.loading);

      final Result result =
          await SendTransactionUseCase().run(actionName: state.actionName, account: state.account, data: state.data);

      yield SendTransactionStateMapper().mapResultToState(state, result, event.rates);
    }
  }
}
