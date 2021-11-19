import 'dart:async';

import 'package:async/async.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/mappers/all_delegates_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/mappers/initial_vote_data_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/mappers/remaining_time_state_mapper.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/usecases/get_all_delegates_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/usecases/get_initial_vote_section_data_use_case.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/campaign_delegate.dart';
import 'package:seeds/screens/explore_screens/vote_screens/vote/interactor/viewmodels/current_remaining_time.dart';

part 'vote_event.dart';
part 'vote_state.dart';

class VoteBloc extends Bloc<VoteEvent, VoteState> {
  StreamSubscription<int>? _tickerSubscription;

  VoteBloc() : super(VoteState.initial(remoteConfigurations.featureFlagDelegateEnabled, settingsStorage.isCitizen)) {
    on<OnFetchInitialVoteSectionData>(_onFetchInitialVoteSectionData);
    on<Tick>(_onTick);
    on<OnRefreshCurrentDelegates>(_onRefreshCurrentDelegates);
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<int> _tick({required int ticks, required int duration}) {
    return Stream.periodic(Duration(seconds: duration), (x) => ticks - x - 1).take(ticks);
  }

  Future<void> _onFetchInitialVoteSectionData(OnFetchInitialVoteSectionData event, Emitter<VoteState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final List<Result> results = await GetInitialVoteSectionDataUseCase().run();
    emit(InitialVoteDataStateMapper().mapResultToState(state, results));
    await _tickerSubscription?.cancel();
    _tickerSubscription = _tick(
      ticks: state.cycleEndTimestamp,

      /// if the vote cycle has ended, we poll for a new state every 1 minute
      /// active vote cycle - showing the seconds countdown
      duration: state.voteCycleHasEnded ? 60 : 1,
    ).listen((timer) => add(Tick(timer)));
  }

  Future<void> _onTick(Tick event, Emitter<VoteState> emit) async {
    if (state.cycleEndTimestamp > DateTime.now().millisecondsSinceEpoch) {
      emit(RemainingTimeStateMapper().mapResultToState(state));
    } else {
      add(OnFetchInitialVoteSectionData()); // Fetch new cycle
    }
  }

  Future<void> _onRefreshCurrentDelegates(OnRefreshCurrentDelegates event, Emitter<VoteState> emit) async {
    final List<Result> results = await GetAllDelegatesDataUseCase().run();
    emit(AllDelegatesStateMapper().mapResultToState(state, results));
  }
}
