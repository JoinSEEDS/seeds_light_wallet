import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_event.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_state.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/app/interactor/mappers/approve_guardian_recovery_state_mapper.dart';
import 'package:seeds/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:seeds/screens/app/interactor/usecases/approve_guardian_recovery_use_case.dart';
import 'package:seeds/screens/app/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/screens/app/interactor/usecases/guardians_recovery_alert_use_case.dart';
import 'package:seeds/screens/app/interactor/usecases/stop_guardian_recovery_use_case.dart';
import 'package:seeds/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/screens/app/interactor/viewmodels/bloc.dart';
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

/// --- BLOC
class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<bool> _shouldShowCancelGuardianAlertMessage;
  final DeeplinkBloc _deeplinkBloc;

  AppBloc(this._deeplinkBloc)
      : super(AppState.initial(
          _deeplinkBloc.state.guardianRecoveryRequestData,
        )) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    _shouldShowCancelGuardianAlertMessage = RecoveryAlertUseCase()
        .shouldShowCancelGuardianAlertMessage
        .listen((value) => add(ShouldShowGuardianRecoveryAlert(showGuardianRecoveryAlert: value)));

    _deeplinkBloc.stream.listen((DeeplinkState deepLinkState) {
      if (deepLinkState.guardianRecoveryRequestData != null) {
        add(OnApproveGuardianRecoveryDeepLink(deepLinkState.guardianRecoveryRequestData!));
      } else if (deepLinkState.signingRequest != null) {
        add(OnSigningRequest(deepLinkState.signingRequest!));
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
      final result = await StopGuardianRecoveryUseCase().stopRecovery();
      yield StopGuardianRecoveryStateMapper().mapResultToState(state, result);
    } else if (event is ClearAppPageCommand) {
      yield state.copyWith(
        showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
      );
    } else if (event is OnDismissGuardianRecoveryTapped) {
      // Update Deep Link Bloc State
      _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
      yield state.copyWith();
    } else if (event is OnApproveGuardianRecoveryTapped) {
      // Update Deep Link Bloc State
      _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
      yield state.copyWith(pageState: PageState.loading);
      final result = await ApproveGuardianRecoveryUseCase()
          .approveGuardianRecovery(event.data.guardianAccount, event.data.publicKey);
      yield ApproveGuardianRecoveryStateMapper().mapResultToState(state, result);
    } else if (event is OnApproveGuardianRecoveryDeepLink) {
      yield state.copyWith(showGuardianApproveOrDenyScreen: event.data);
    } else if (event is OnSigningRequest) {
      final args = SendConfirmationArguments(
        account: event.esr.accountName,
        name: event.esr.actionName,
        data: event.esr.data,
      );
      yield state.copyWith(
        pageState: PageState.success,
        pageCommand: NavigateToRouteWithArguments(route: Routes.sendConfirmationScreen, arguments: args),
      );
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }
}
