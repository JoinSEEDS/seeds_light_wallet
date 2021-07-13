import 'dart:async';
import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/singing_request_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/get_incoming_deep_link.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/get_initial_deep_link.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/guardians_recovery_alert_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/stop_guardian_recovery_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/app_page_commands.dart';
import 'package:seeds/v2/screens/app/interactor/viewmodels/bloc.dart';
import 'package:uni_links/uni_links.dart';

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
    if (event is HandleInitialDeepLink) {
      /// Handle the initial Uri - the one the app was started with
      ///
      /// **ATTENTION**: `getInitialLink` should be handled
      /// ONLY ONCE in your app's lifetime, since it is not meant to change
      /// throughout your app's life.
      Result result = await GetInitialDeepLinkUseCase().run();
      yield SingingRequestStateMapper().mapResultToState(state, result);
      linkStream.listen((newLink) => add(HandleIncomingDeepLink(newLink)));
    }
    if (event is HandleIncomingDeepLink) {
      /// Handle incoming links - the ones that the app will recieve from the OS
      /// while already started.
      Result result = await GetIncomingDeepLinkUseCase().run(event.newLink);
      yield SingingRequestStateMapper().mapResultToState(state, result);
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
    } else if (event is ClearAppPageCommand) {
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
