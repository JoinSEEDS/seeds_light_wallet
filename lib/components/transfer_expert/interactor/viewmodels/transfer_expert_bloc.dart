import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:seeds/components/transfer_expert/interactor/mappers/transfer_expert_state_mapper.dart';
import 'package:seeds/components/search_user/interactor/usecases/search_for_user_use_case.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_state.dart';


part 'transfer_expert_event.dart';
part 'transfer_expert_state.dart';

class TransferExpertBloc extends Bloc<TransferExpertEvent, TransferExpertState> {
  final int _minTextLengthBeforeValidSearch = 2;

  TransferExpertBloc(List<String>? noShowUsers, ProfileStatus? filterByCitizenshipStatus)
      : super(TransferExpertState.initial(noShowUsers, filterByCitizenshipStatus)) {
    on<OnSearchChange>(_onSearchChange, transformer: _transformEvents);
    on<ClearIconTapped>(_clearIconTapped);
  }

  /// Debounce to avoid making search network calls each time the user types
  /// switchMap: To remove the previous event. Every time a        print('From ${state.selectedAccounts["from"]}'); new Stream is created, the previous Stream is discarded.
  Stream<OnSearchChange> _transformEvents(
      Stream<OnSearchChange> events, Stream<OnSearchChange> Function(OnSearchChange) transitionFn) {
    return events.debounceTime(const Duration(milliseconds: 300)).switchMap(transitionFn);
  }

  Future<void> _onSearchChange(OnSearchChange event, Emitter<TransferExpertState> emit) async {
    final newSelectedAccounts = Map<String, String>.from(state.selectedAccounts);
    newSelectedAccounts[event.accountKey] = event.searchQuery;
    emit(state.copyWith(
      pageState: PageState.loading,
      showClearIcon: event.searchQuery.isNotEmpty,
      selectedAccounts: newSelectedAccounts,
    ));
  }

  void _clearIconTapped(ClearIconTapped event, Emitter<TransferExpertState> emit) {
    emit(TransferExpertState.initial(state.noShowUsers, state.showOnlyCitizenshipStatus));
  }
}
