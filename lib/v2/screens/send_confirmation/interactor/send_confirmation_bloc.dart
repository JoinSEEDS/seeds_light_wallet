import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore/interactor/mappers/explore_state_mapper.dart';
import 'package:seeds/v2/screens/explore/interactor/usecases/get_explore_page_data_use_case.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_events.dart';
import 'package:seeds/v2/screens/explore/interactor/viewmodels/explore_state.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_events.dart';
import 'package:seeds/v2/screens/send_confirmation/interactor/viewmodels/send_confirmation_state.dart';


/// --- BLOC
class SendConfirmationBloc extends Bloc<SendConfirmationEvent, SendConfirmationState> {
  SendConfirmationBloc() : super(SendConfirmationState.initial());

  @override
  Stream<SendConfirmationState> mapEventToState(SendConfirmationEvent event) async* {
    if (event is LoadSendConfirmation) {
      yield state.copyWith(pageState: PageState.loading);

      // var results = await GetExploreUseCase().run(event.userName);

      // yield SendConfirmationStateMapper().mapResultsToState(state, results);
    }
  }
}
