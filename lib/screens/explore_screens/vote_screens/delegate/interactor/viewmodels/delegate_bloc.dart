import 'package:bloc/bloc.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_event.dart';
import 'package:seeds/screens/explore_screens/vote_screens/delegate/interactor/viewmodels/delegate_state.dart';

class DelegateBloc extends Bloc<DelegateEvent, DelegateState> {
  DelegateBloc() : super(DelegateState.initial());

  @override
  Stream<DelegateState> mapEventToState(DelegateEvent event) async* {
    if (event is LoadDelegateData) {
      yield state.copyWith(pageState: PageState.success);
    }
  }
}
