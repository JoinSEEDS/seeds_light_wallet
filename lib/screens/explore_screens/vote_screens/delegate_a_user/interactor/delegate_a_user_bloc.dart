import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_events.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_page_commands.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate_a_user/interactor/viewmodel/delegate_a_user_state.dart';

class DelegateAUserBloc extends Bloc<DelegateAUserEvent, DelegateAUserState> {
  DelegateAUserBloc() : super(DelegateAUserState.initial());

  @override
  Stream<DelegateAUserState> mapEventToState(DelegateAUserEvent event) async* {
    if (event is OnUserSelected) {
      yield state.copyWith(pageState: PageState.success, pageCommand: ShowDelegateConfirmation(event.user));
    } else if (event is OnConfirmDelegateTab) {
      //next pr
    } else if (event is ClearPageCommand) {
      yield state.copyWith();
    }
  }
}
