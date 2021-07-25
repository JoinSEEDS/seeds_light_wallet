import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/approve_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/guardian_approve_or_deny_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/mappers/stop_guardian_recovery_state_mapper.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/approve_guardian_recovery_use_case.dart';
import 'package:seeds/v2/screens/app/interactor/usecases/get_initial_deep_link.dart';
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

    initDynamicLinks();
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ShouldShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is HandleIncomingFirebaseDeepLink) {
      var result = await GetInitialDeepLinkUseCase().run(event.newLink);
      yield GuardianApproveOrDenyStateMapper().mapResultToState(state, result);
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
    } else if (event is OnDismissGuardianRecoveryTapped) {
      yield state.copyWith(pageCommand: null, showGuardianApproveOrDenyScreen: null);
    } else if (event is OnApproveGuardianRecoveryTapped) {
      yield state.copyWith(pageState: PageState.loading);
      var result = await ApproveGuardianRecoveryUseCase()
          .approveGuardianRecovery(event.data.guardianAccount, event.data.publicKey);
      yield ApproveGuardianRecoveryStateMapper().mapResultToState(state, result);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending.cancel();
    _shouldShowCancelGuardianAlertMessage.cancel();
    return super.close();
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(onError: (error) async {
      print('onLinkError');
      print(error.message);
    }, onSuccess: (dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('onSuccess');
        print(deepLink.toString());
        print(deepLink.data.toString());
        add(HandleIncomingFirebaseDeepLink(deepLink));
      }
    });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print('PendingDynamicLinkData');
      print(deepLink.data.toString());
      print(deepLink.toString());
      add(HandleIncomingFirebaseDeepLink(deepLink));
    }
  }
}
