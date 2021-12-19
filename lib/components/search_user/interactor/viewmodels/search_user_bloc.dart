import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/search_user/interactor/mappers/search_user_state_mapper.dart';
import 'package:seeds/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/datasource/remote/model/member_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/user_citizenship_status.dart';

part 'search_user_event.dart';
part 'search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final int _minTextLengthBeforeValidSearch = 2;

  SearchUserBloc(List<String>? noShowUsers, UserCitizenshipStatus? filterByCitizenshipStatus)
      : super(SearchUserState.initial(noShowUsers, filterByCitizenshipStatus)) {
    on<OnSearchChange>(_onSearchChange);
    on<ClearIconTapped>(_clearIconTapped);
  }

  @override
  Stream<Transition<SearchUserEvent, SearchUserState>> transformEvents(
    Stream<SearchUserEvent> events,
    // ignore: deprecated_member_use
    TransitionFunction<SearchUserEvent, SearchUserState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) => event is ClearIconTapped);

    final debounceStream =
        events.where((event) => event is OnSearchChange).debounceTime(const Duration(milliseconds: 300));

    // Debounce to avoid making search network calls each time the user types
    // switchMap: To remove the previous event. Every time a new Stream is created, the previous Stream is discarded.
    return MergeStream([nonDebounceStream, debounceStream]).switchMap(transitionFn);
  }

  Future<void> _onSearchChange(OnSearchChange event, Emitter<SearchUserState> emit) async {
    emit(state.copyWith(pageState: PageState.loading, showClearIcon: event.searchQuery.isNotEmpty));
    if (event.searchQuery.length > _minTextLengthBeforeValidSearch) {
      final results = await SearchForMemberUseCase().run(event.searchQuery);
      emit(SearchUserStateMapper().mapResultToState(
        currentState: state,
        seedsMembersResult: results[0],
        telosResult: results[1],
        fullNameResult: results[2],
        noShowUsers: state.noShowUsers,
      ));
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  void _clearIconTapped(ClearIconTapped event, Emitter<SearchUserState> emit) {
    emit(SearchUserState.initial(state.noShowUsers, state.showOnlyCitizenshipStatus));
  }
}
