import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_recovery_alert_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/stop_guardian_recovery_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';

/// --- BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<bool> _shouldShowCancelGuardianAlertMessage;

  AppBloc() : super(AppState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    _shouldShowCancelGuardianAlertMessage = RecoveryAlertUseCase()
        .shouldShowCancelGuardianAlertMessage
        .listen((value) => add(ShouldShowGuardianRecoveryAlert(showGuardianRecoveryAlert: value)));
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is BottomBarTapped) {
      yield state.copyWith(index: event.index, pageCommand: BottomBarNavigateToIndex(event.index));
    }
    if (event is ShouldShowGuardianRecoveryAlert) {
      yield state.copyWith(showGuardianRecoveryAlert: event.showGuardianRecoveryAlert);
    }
    if (event is OnStopGuardianActiveRecoveryTapped) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await StopGuardianRecoveryUseCase().stopRecovery();
      yield StopGuardianRecoveryStateMapper().mapResultToState(state, result);
    } else if (event is ClearPageCommand) {
      yield state.copyWith(pageCommand: null);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }
}
