import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';

/// --- BLOC
class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc() : super(SendConfirmationState.initial());

  @override
  Stream<SendConfirmationState> mapEventToState(SendConfirmationEvent event) async* {
    if (event is InitSendConfirmationWithArguments) {
      yield state.copyWith(
        pageState: PageState.success,
        data: event.arguments.data,
        name: event.arguments.name,
        account: event.arguments.account,
      );

      print("Arguments" + event.arguments.toString());
      print("Arguments" + event.arguments.data.toString());
      print("Arguments" + event.arguments.account.toString());
      print("Arguments" + event.arguments.name.toString());

      // var results = await GetExploreUseCase().run(event.userName);

      // yield SendConfirmationStateMapper().mapResultsToState(state, results);
    }
  }
}
