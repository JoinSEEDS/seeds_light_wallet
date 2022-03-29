import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/blocs/deeplink/model/guardian_recovery_request_data.dart';
import 'package:seeds/blocs/deeplink/viewmodels/deeplink_bloc.dart';
import 'package:seeds/datasource/local/models/scan_qr_code_result_data.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_analytics_service.dart';
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
import 'package:seeds/screens/transfer/send/send_confirmation/interactor/viewmodels/send_confirmation_arguments.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  late StreamSubscription<bool> _hasGuardianNotificationPending;
  late StreamSubscription<bool> _shouldShowCancelGuardianAlertMessage;
  final DeeplinkBloc _deeplinkBloc;
  final AuthenticationBloc _authenticationBloc;

  AppBloc(this._deeplinkBloc, this._authenticationBloc)
      : super(AppState.initial(_deeplinkBloc.state.guardianRecoveryRequestData)) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShouldShowNotificationBadge(value: value)));

    _shouldShowCancelGuardianAlertMessage = RecoveryAlertUseCase()
        .shouldShowCancelGuardianAlertMessage
        .listen((value) => add(ShouldShowGuardianRecoveryAlert(showGuardianRecoveryAlert: value)));

    _deeplinkBloc.stream.listen((deepLinkState) {
      if (deepLinkState.guardianRecoveryRequestData != null) {
        add(OnApproveGuardianRecoveryDeepLink(deepLinkState.guardianRecoveryRequestData!));
      } else if (deepLinkState.signingRequest != null && !_authenticationBloc.state.isOnResumeAuth) {
        // When user clicks a signing deeplink
        // iOS S.O. opens the same previous opened app instance
        // so we need catch that the app is on resume auth to
        // avoid an unwanted navigation over the passcode screen
        add(OnSigningRequest(deepLinkState.signingRequest!));
      }
    });

    _authenticationBloc.stream.listen((authenticationState) {
      if (!authenticationState.isOnResumeAuth && _deeplinkBloc.state.signingRequest != null) {
        // When user clicks a signing deeplink (iOS O.S.)
        // the second part once on resume auth completes
        // launch any signing request deeplink
        add(OnSigningRequest(_deeplinkBloc.state.signingRequest!));
      }
    });

    on<OnAppMounted>(_onAppMounted);
    on<ShouldShowNotificationBadge>(_shouldShowNotificationBadge);
    on<BottomBarTapped>(_bottomBarTapped);
    on<ShouldShowGuardianRecoveryAlert>(_shouldShowGuardianRecoveryAlert);
    on<OnStopGuardianActiveRecoveryTapped>(_onStopGuardianActiveRecovery);
    on<ClearAppPageCommand>(_clearAppPageCommand);
    on<OnDismissGuardianRecoveryTapped>(_onDismissGuardianRecoveryTapped);
    on<OnApproveGuardianRecoveryTapped>(_onApproveGuardianRecoveryTapped);
    on<OnApproveGuardianRecoveryDeepLink>(_onApproveGuardianRecoveryDeepLink);
    on<OnSigningRequest>(_onSigningRequest);
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }

  Future<void> _onAppMounted(OnAppMounted event, Emitter<AppState> emit) async {
    // The first time app widged is mounted, check if there is a signing request waiting.
    if (_deeplinkBloc.state.signingRequest != null) {
      // When user clicks a signing deeplink
      // Android S.O. creates a new app instance and starts from launch
      // even if there is already one open, so we need catch that link
      // when app widget is mounted for first time.
      add(OnSigningRequest(_deeplinkBloc.state.signingRequest!));
      // keep show loading during transition to confirm transaction
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(pageState: PageState.initial));
    } else {
      emit(state.copyWith(pageState: PageState.initial));
    }
    await FirebaseAnalyticsService().setUserId(settingsStorage.accountName);
  }

  void _shouldShowNotificationBadge(ShouldShowNotificationBadge event, Emitter<AppState> emit) {
    emit(state.copyWith(
      hasNotification: event.value,
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
  }

  Future<void> _bottomBarTapped(BottomBarTapped event, Emitter<AppState> emit) async {
    emit(state.copyWith(
      index: event.index,
      pageCommand: BottomBarNavigateToIndex(event.index),
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
    await FirebaseAnalyticsService().sendEvent('BottomBarTapped', {'index': event.index});
  }

  void _shouldShowGuardianRecoveryAlert(ShouldShowGuardianRecoveryAlert event, Emitter<AppState> emit) {
    emit(state.copyWith(
      showGuardianRecoveryAlert: event.showGuardianRecoveryAlert,
      showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen,
    ));
  }

  Future<void> _onStopGuardianActiveRecovery(OnStopGuardianActiveRecoveryTapped event, Emitter<AppState> emit) async {
    emit(state.copyWith(pageState: PageState.loading));
    final result = await StopGuardianRecoveryUseCase().stopRecovery();
    emit(StopGuardianRecoveryStateMapper().mapResultToState(state, result));
  }

  void _clearAppPageCommand(ClearAppPageCommand event, Emitter<AppState> emit) {
    emit(state.copyWith(showGuardianApproveOrDenyScreen: state.showGuardianApproveOrDenyScreen));
  }

  void _onDismissGuardianRecoveryTapped(OnDismissGuardianRecoveryTapped event, Emitter<AppState> emit) {
    // Update Deep Link Bloc State
    _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
    emit(state.copyWith());
  }

  Future<void> _onApproveGuardianRecoveryTapped(OnApproveGuardianRecoveryTapped event, Emitter<AppState> emit) async {
    // Update Deep Link Bloc State
    _deeplinkBloc.add(const OnGuardianRecoveryRequestSeen());
    emit(state.copyWith(pageState: PageState.loading));
    final result = await ApproveGuardianRecoveryUseCase()
        .approveGuardianRecovery(event.data.guardianAccount, event.data.publicKey);
    emit(ApproveGuardianRecoveryStateMapper().mapResultToState(state, result));
  }

  void _onApproveGuardianRecoveryDeepLink(OnApproveGuardianRecoveryDeepLink event, Emitter<AppState> emit) {
    emit(state.copyWith(showGuardianApproveOrDenyScreen: event.data));
  }

  void _onSigningRequest(OnSigningRequest event, Emitter<AppState> emit) {
    final args = SendConfirmationArguments(transaction: event.esr.transaction);
    emit(state.copyWith(pageCommand: NavigateToRouteWithArguments(route: Routes.sendConfirmation, arguments: args)));
  }
}
