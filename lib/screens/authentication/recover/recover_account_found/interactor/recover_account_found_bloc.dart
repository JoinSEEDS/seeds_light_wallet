import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_event.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/cancel_recovery_use_case.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/mappers/fetch_recover_guardian_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/mappers/remaining_time_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/reset_user_account_use_case.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_events.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_page_command.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_state.dart';

/// --- BLOC
class RecoverAccountFoundBloc extends Bloc<RecoverAccountFoundEvent, RecoverAccountFoundState> {
  RecoverAccountFoundBloc(String userAccount, this._authenticationBloc)
      : super(RecoverAccountFoundState.initial(userAccount));

  final AuthenticationBloc _authenticationBloc;
  StreamSubscription<int>? _tickerSubscription;

  Stream<int> _tick() {
    return Stream.periodic(const Duration(seconds: 1), (x) => x);
  }

  Stream<RecoverAccountFoundState> _mapStartTimerToState() async* {
    _tickerSubscription = _tick().listen((timer) => add(Tick(timer)));
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

      final RecoverGuardianInitialDTO result = await FetchRecoverGuardianInitialDataUseCase().run(state.userAccount);
      final newState = FetchRecoverRecoveryStateMapper().mapResultToState(state, result);
      yield newState;
      if (newState.recoveryStatus == RecoveryStatus.WAITING_FOR_24_HOUR_COOL_PERIOD) {
        yield* _mapStartTimerToState();
      }
    } else if (event is Tick) {
      if (state.timeRemaining > 0) {
        yield RemainingTimeStateMapper().mapResultToState(state);
      } else {
        await _tickerSubscription?.cancel();
        yield state.copyWith(
          recoveryStatus: RecoveryStatus.READY_TO_CLAIM_ACCOUNT,
          currentRemainingTime: const CurrentRemainingTime(days: 0, hours: 0, min: 0, sec: 0),
        );
      }
    } else if (event is OnClaimAccountTap) {
      yield state.copyWith(pageState: PageState.loading);
      final result = await ResetUserAccountUseCase().run(state.userAccount);
      if (result.isValue) {
        // The private key was saved in the settings storage when the user data for this bloc was loaded
        settingsStorage.finishRecoveryProcess();
        _authenticationBloc.add(OnRecoverAccount(account: state.userAccount, privateKey: settingsStorage.privateKey!));
      } else {
        yield state.copyWith(pageCommand: ShowErrorMessage("Oops, Something went wrong. Try again later"));
      }
    } else if (event is OnCopyIconTap) {
      yield state.copyWith(pageCommand: ShowLinkCopied());
    } else if (event is OnRefreshTap) {
      add(FetchInitialData());
    } else if (event is ClearRecoverPageCommand) {
      yield state.copyWith();
    } else if (event is OnCancelProcessTap) {
      CancelRecoveryProcessUseCase().run();
      yield state.copyWith(pageCommand: CancelRecoveryProcess());
    }
  }
}
