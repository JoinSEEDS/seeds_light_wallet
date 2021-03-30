import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:seeds/providers/notifiers/auth_notifier.dart';
import 'package:seeds/providers/notifiers/settings_notifier.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  // TODO(raul): Remove usage of _settingsNotifier and AuthNotifier. We need them for now to not break other areas, https://github.com/JoinSEEDS/seeds_light_wallet/pull/620
  final SettingsNotifier settingsNotifier;
  final AuthNotifier authNotifier;
  StreamSubscription<bool> _hasGuardianNotificationPending;

  SecurityBloc({@required this.settingsNotifier, @required this.authNotifier}) : super(SecurityState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShowNotificationBadge(value: value)));
  }

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is SetUpInitialValues) {
      yield state.copyWith(
        pageState: PageState.success,
        isSecurePasscode: settingsNotifier.passcodeActive ? true : null,
        isSecureBiometric: true,
      );
    }
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnGuardiansCardTapped) {
      yield state.copyWith(navigateToGuardians: null); //reset
      if (state.hasNotification) {
        await FirebaseDatabaseService().removeGuardianNotification(settingsStorage.accountName);
      }
      yield state.copyWith(navigateToGuardians: true);
    }
    if (event is OnPinChanged) {
      if (state.isSecurePasscode) {
        yield state.copyWith(isSecurePasscode: null);
        settingsNotifier.passcode = null;
        settingsNotifier.passcodeActive = false;
        authNotifier.disablePasscode();
        authNotifier.resetPasscode();
      } else {
        yield state.copyWith(isSecurePasscode: true);
        settingsNotifier.passcodeActive = true;
      }
    }
    if (event is OnBiometricsChanged) {
      yield state.copyWith(isSecureBiometric: !state.isSecureBiometric);
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending?.cancel();
    return super.close();
  }
}
