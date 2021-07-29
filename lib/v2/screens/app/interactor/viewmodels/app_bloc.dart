import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/v2/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/approve_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/approve_guardian_recovery_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_recovery_alert_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/stop_guardian_recovery_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';

/// --- BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<bool> _shouldShowCancelGuardianAlertMessage;
  final DeeplinkBloc _deeplinkBloc;

  AppBloc(this._deeplinkBloc) : super(AppState.initial(_deeplinkBloc.state.guardianRecoveryRequestData)) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    _shouldShowCancelGuardianAlertMessage = RecoveryAlertUseCase()
        .shouldShowCancelGuardianAlertMessage
        .listen((value) => add(ShouldShowGuardianRecoveryAlert(showGuardianRecoveryAlert: value)));

    _deeplinkBloc.stream.listen((DeeplinkState event) {
      if (event.guardianRecoveryRequestData != null) {
        add(OnApproveGuardianRecoveryDeepLink(event.guardianRecoveryRequestData!));
      }
    });
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(
        hasNotification: event.value,
        showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
      );
    }
    if (event is BottomBarTapped) {
      yield state.copyWith(
        index: event.index,
        pageCommand: BottomBarNavigateToIndex(event.index),
        showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
      );
    }
    if (event is ShouldShowGuardianRecoveryAlert) {
      yield state.copyWith(
        showGuardianRecoveryAlert: event.showGuardianRecoveryAlert,
        showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
      );
    }
    if (event is OnStopGuardianActiveRecoveryTapped) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await StopGuardianRecoveryUseCase().stopRecovery();
      yield StopGuardianRecoveryStateMapper().mapResultToState(state, result);
    } else if (event is ClearAppPageCommand) {
      yield state.copyWith(
        pageCommand: null,
        showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
      );
    } else if (event is OnDismissGuardianRecoveryTapped) {
      // Update Deep Link Bloc State
      _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
      yield state.copyWith(pageCommand: null, showGuardianApproveOrDenyScreen: null);
    } else if (event is OnApproveGuardianRecoveryTapped) {
      // Update Deep Link Bloc State
      _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
      yield state.copyWith(pageState: PageState.loading);
      var result = await ApproveGuardianRecoveryUseCase()
          .approveGuardianRecovery(event.data.guardianAccount, event.data.publicKey);
      yield ApproveGuardianRecoveryStateMapper().mapResultToState(state, result);
    } else if (event is OnApproveGuardianRecoveryDeepLink) {
      yield state.copyWith(showGuardianApproveOrDenyScreen: event.data);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }
}
