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
        isSecurePin: settingsNotifier.passcodeActive,
        isSecureBiometric: true,
      );
    }
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnGuardiansCardTapped) {
      yield state.copyWith(navigateToGuardians: false); //reset
      if (state.hasNotification) {
        await FirebaseDatabaseService().removeGuardianNotification(settingsStorage.accountName);
      }
      yield state.copyWith(navigateToGuardians: true);
    }
    if (event is OnPinChanged) {
      if (state.isSecurePin) {
        yield state.copyWith(isSecurePin: false);
        settingsNotifier.passcode = null;
        settingsNotifier.passcodeActive = false;
        authNotifier.disablePasscode();
        authNotifier.resetPasscode();
      } else {
        yield state.copyWith(isSecurePin: true);
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
