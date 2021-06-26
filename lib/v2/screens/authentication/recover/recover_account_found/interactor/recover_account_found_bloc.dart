import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_event.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/mappers/fetch_recover_guardian_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/mappers/remaining_time_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/v2/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

/// --- BLOC
class RecoverAccountFoundBloc extends Bloc<RecoverAccountFoundEvent, RecoverAccountFoundState> {
  RecoverAccountFoundBloc(List<String> userGuardians, String userAccount, this._authenticationBloc)
      : super(RecoverAccountFoundState.initial(userGuardians, userAccount));

  final AuthenticationBloc _authenticationBloc;
  StreamSubscription<int>? _tickerSubscription;

  Stream<int> _tick(int ticks) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }

  Stream<RecoverAccountFoundState> _mapStartTimerToState() async* {
    _tickerSubscription = _tick(state.timeLockSeconds).listen((timer) => add(Tick(timer)));
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<RecoverAccountFoundState> mapEventToState(RecoverAccountFoundEvent event) async* {
    if (event is FetchInitialData) {
      yield state.copyWith(pageState: PageState.loading);
      RecoverGuardianInitialDTO result = await FetchRecoverGuardianInitialDataUseCase().run(state.userGuardians);
      yield FetchRecoverRecoveryStateMapper().mapResultToState(state, result);
      yield* _mapStartTimerToState();
    } else if (event is Tick) {
      if (event.timer > DateTime.now().millisecondsSinceEpoch ~/ 1000) {
        yield RemainingTimeStateMapper().mapResultToState(state, event.timer);
      } else {
        await _tickerSubscription?.cancel();
        // TODO(gguij002): Show account ready to claim UI
      }
    } else if (event is OnClaimAccountTap) {
      _authenticationBloc.add(OnImportAccount(account: state.userAccount, privateKey: settingsStorage.privateKey!));
    }
  }
}
