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

  VoteBloc() : super(VoteState.initial(remoteConfigurations.featureFlagDelegateEnabled, settingsStorage.isCitizen));

  Stream<int> _tick(int ticks) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }

  Stream<VoteState> _mapStartTimerToState() async* {
    _tickerSubscription = _tick(state.remainingTimeStamp).listen((timer) => add(Tick(timer)));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<VoteState> mapEventToState(VoteEvent event) async* {
    if (event is OnFetchInitialVoteSectionData) {
      yield state.copyWith(pageState: PageState.loading);
      final List<Result> results = await GetInitialVoteSectionDataUseCase().run();
      yield InitialVoteDataStateMapper().mapResultToState(state, results);
      yield* _mapStartTimerToState();
    }
    if (event is Tick) {
      if (event.timer > DateTime.now().millisecondsSinceEpoch) {
        yield RemainingTimeStateMapper().mapResultToState(state, event.timer);
      } else {
        await _tickerSubscription?.cancel();
        // Fetch new cycle
        add(OnFetchInitialVoteSectionData());
      }
    }
    if (event is OnRefreshCurrentDelegates) {
      final List<Result> results = await GetAllDelegatesDataUseCase().run();
      yield AllDelegatesStateMapper().mapResultToState(state, results);
    }
  }
}
