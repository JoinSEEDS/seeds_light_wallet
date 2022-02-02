import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/profile_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/shared_use_cases/cancel_recovery_use_case.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/mappers/fetch_recover_guardian_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/mappers/remaining_time_state_mapper.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/fetch_recover_guardian_initial_data.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/usecases/reset_user_account_use_case.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/current_remaining_time.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/interactor/viewmodels/recover_account_found_page_command.dart';
import 'package:seeds/screens/authentication/recover/recover_account_found/recover_account_found_errors.dart';

part 'recover_account_found_event.dart';

part 'recover_account_found_state.dart';

class RecoverAccountFoundBloc extends Bloc<RecoverAccountFoundEvent, RecoverAccountFoundState> {
  StreamSubscription<int>? _tickerSubscription;

  RecoverAccountFoundBloc(String userAccount) : super(RecoverAccountFoundState.initial(userAccount)) {
    on<FetchInitialData>(_fetchInitialData);
    on<Tick>(_onTick);
    on<OnClaimAccountTapped>(_onClaimAccountTapped);
    on<OnCopyIconTapped>((_, emit) => emit(state.copyWith(pageCommand: ShowLinkCopied())));
    on<OnRefreshTapped>((_, __) => add(const FetchInitialData()));
    on<ClearRecoverPageCommand>((_, emit) => emit(state.copyWith()));
    on<OnCancelProcessTapped>(_onCancelProcessTapped);
  }

  Stream<int> _tick() => Stream.periodic(const Duration(seconds: 1), (x) => x);

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Future<void> _fetchInitialData(FetchInitialData event, Emitter<RecoverAccountFoundState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final RecoverGuardianInitialDTO result = await FetchRecoverGuardianInitialDataUseCase().run(state.userAccount);
    final newState = FetchRecoverRecoveryStateMapper().mapResultToState(state, result);
    emit(newState);
    if (newState.recoveryStatus == RecoveryStatus.waitingFor24HourCoolPeriod) {
      await _tickerSubscription?.cancel();
      _tickerSubscription = _tick().listen((timer) => add(Tick(timer)));
    }
  }

  Future<void> _onTick(Tick event, Emitter<RecoverAccountFoundState> emit) async {
    if (state.timeRemaining > 0) {
      emit(RemainingTimeStateMapper().mapResultToState(state));
    } else {
      await _tickerSubscription?.cancel();
      emit(state.copyWith(
        recoveryStatus: RecoveryStatus.readyToClaimAccount,
        currentRemainingTime: const CurrentRemainingTime(days: 0, hours: 0, min: 0, sec: 0),
      ));
    }
  }

  Future<void> _onClaimAccountTapped(OnClaimAccountTapped event, Emitter<RecoverAccountFoundState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await ResetUserAccountUseCase().run(state.userAccount);
    if (result.isValue) {
      emit(state.copyWith(pageCommand: OnRecoverAccountSuccess()));
    } else {
      emit(state.copyWith(pageCommand: ShowErrorMessage("Oops, Something went wrong. Try again later")));
    }
  }

  void _onCancelProcessTapped(OnCancelProcessTapped event, Emitter<RecoverAccountFoundState> emit) {
    CancelRecoveryProcessUseCase().run();
    emit(state.copyWith(pageCommand: CancelRecoveryProcess()));
  }
}
