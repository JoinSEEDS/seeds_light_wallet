import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/v2/components/search_user/interactor/mappers/search_user_state_mapper.dart';
import 'package:seeds/v2/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_events.dart';
import 'package:seeds/v2/components/search_user/interactor/viewmodels/search_user_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- BLOC
class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final num _MIN_TEXT_LENGTH_BEFORE_VALID_SEARCH = 2;

 // SelectGuardiansBloc(List<GuardianModel> myGuardians) : super(SelectGuardiansState.initial(myGuardians))
  SearchUserBloc(List<String> noShowUsers) : super(SearchUserState.initial(noShowUsers)){
    print("Inside search Bloc init");
    print(noShowUsers);
  }

  @override
  Stream<Transition<SearchUserEvent, SearchUserState>> transformEvents(
    Stream<SearchUserEvent> events,
    TransitionFunction<SearchUserEvent, SearchUserState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is ClearIconTapped);

    final debounceStream =
        events.where((event) => event is OnSearchChange).debounceTime(const Duration(milliseconds: 500));

    // Debounce 500 MS to avoid making search network calls each time the user types
    // switchMap: To remove the previous event. Every time a new Stream is created, the previous Stream is discarded.
    return MergeStream([nonDebounceStream, debounceStream]).switchMap(transitionFn);
  }

  @override
  Stream<SearchUserState> mapEventToState(SearchUserEvent event) async* {
    if (event is OnSearchChange) {
      if (event.searchQuery.isEmpty) {
        yield state.copyWith(searchBarIcon: Icons.search);
      } else {
        yield state.copyWith(searchBarIcon: Icons.clear);
      }

      if (event.searchQuery.length > _MIN_TEXT_LENGTH_BEFORE_VALID_SEARCH) {
        yield state.copyWith(pageState: PageState.loading);
        var result = await SearchForMemberUseCase().run(event.searchQuery);
        print("search Bloc before calling mapper");
        print(state.noShowUsers);
        yield SearchUserStateMapper().mapResultToState(state, result, state.noShowUsers);
      }
    } else if (event is ClearIconTapped) {
      yield SearchUserState.initial(null);
    }
  }
}
