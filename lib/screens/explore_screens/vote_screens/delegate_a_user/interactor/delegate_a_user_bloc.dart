import 'package:bloc/bloc.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_events.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_state.dart';

class DelegateAUserBloc extends Bloc<DelegateAUserEvent, DelegateAUserState> {
  DelegateAUserBloc() : super(DelegateAUserState.initial());

  @override
  Stream<DelegateAUserState> mapEventToState(DelegateAUserEvent event) async* {
    if (event is OnUserSelected) {
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
