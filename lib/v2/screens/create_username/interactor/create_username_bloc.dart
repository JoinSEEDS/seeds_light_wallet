import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/create_username/interactor/viewmodels/create_username_events.dart';
import 'package:seeds/v2/screens/create_username/interactor/viewmodels/create_username_state.dart';

/// --- BLOC
class CreateUsernameBloc extends Bloc<CreateUsernameEvent, CreateUsernameState> {
  CreateUsernameBloc() : super(CreateUsernameState.initial());

  @override
  Stream<CreateUsernameState> mapEventToState(CreateUsernameEvent event) async* {
    if (event is OnUsernameChange) {

      yield state.copyWith(isValidUsername: isValidUsername(event.userName));

      // yield state.copyWith(pageState: PageState.loading);


      //
      // var results = await GetExploreUseCase().run(event.userName);
      //
      // yield ExploreStateMapper().mapResultsToState(state, results);
    }
  }
}

bool isValidUsername(String username) {
  if(username.length < 12) {
    return false;
  } else {
    return true;
  }
}
