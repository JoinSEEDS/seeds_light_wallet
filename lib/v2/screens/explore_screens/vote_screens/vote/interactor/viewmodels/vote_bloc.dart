import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import '../mappers/next_moon_phase_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/mappers/remaining_time_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/usecases/get_next_moon_phase.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/vote/interactor/viewmodels/bloc.dart';

/// --- BLOC
class VoteBloc extends Bloc<VoteEvent, VoteState> {
  StreamSubscription<int>? _tickerSubscription;

  VoteBloc() : super(VoteState.initial());

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
    if (event is StartCycleCountdown) {
      yield state.copyWith(pageState: PageState.loading);
      Result result = await GetNextMoonPhaseUseCase().run();
      yield NextMoonPhaseStateMapper().mapResultToState(state, result);
      yield* _mapStartTimerToState();
    }
    if (event is Tick) {
      if (event.timer > DateTime.now().millisecondsSinceEpoch) {
        yield RemainingTimeStateMapper().mapResultToState(state, event.timer);
      } else {
        await _tickerSubscription?.cancel();
        // Fetch new cycle
        add(StartCycleCountdown());
      }
    }
  }
}
