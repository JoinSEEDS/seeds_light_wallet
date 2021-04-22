import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/v2/components/search_user/interactor/mappers/search_user_state_mapper.dart';
import 'package:seeds/v2/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_events.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';

/// --- BLOC
class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  SearchUserBloc() : super(SearchUserState.initial());

  @override
  Stream<Transition<SearchUserEvent, SearchUserState>> transformEvents(
      Stream<SearchUserEvent> events, TransitionFunction<SearchUserEvent, SearchUserState> transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 500)).switchMap(transitionFn);
  }

  @override
  Stream<SearchUserState> mapEventToState(SearchUserEvent event) async* {
    if (event is OnSearchChange) {
      if (event.searchQuery.length > 2) {
        var result = await SearchForMemberUseCase().run(event.searchQuery);
        yield SearchUserStateMapper().mapResultToState(state, result);
      }
    }
  }
}
