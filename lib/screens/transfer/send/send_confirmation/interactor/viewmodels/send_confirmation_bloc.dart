import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/bloc.dart';
import 'package:seeds/datasource/local/models/eos_transaction.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/mappers/send_transaction_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/usecases/send_transaction_use_case.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_commands.dart';

part 'send_confirmation_event.dart';
part 'send_confirmation_state.dart';

class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc(SendConfirmationArguments arguments) : super(SendConfirmationState.initial(arguments)) {
    on<SendTransactionEvent>(_sendTransactionEvent);
  }

  Future<void> _sendTransactionEvent(SendTransactionEvent event, Emitter<SendConfirmationState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final Result result = await SendTransactionUseCase().run(state.transaction);
    emit(SendTransactionStateMapper().mapResultToState(state, result, event.rates));
  }
}
