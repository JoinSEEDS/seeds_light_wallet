import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:seeds/providers/services/firebase/firebase_database_service.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/usecases/guardians_notification_use_case.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  final AuthenticationBloc _authenticationBloc;
  StreamSubscription<bool?>? _hasGuardianNotificationPending;

  SecurityBloc({required AuthenticationBloc authenticationBloc})
      : _authenticationBloc = authenticationBloc,
        super(SecurityState.initial()) {
    _hasGuardianNotificationPending = GuardiansNotificationUseCase()
        .hasGuardianNotificationPending
        .listen((value) => add(ShowNotificationBadge(value: value!)));
  }

  @override
  Stream<SecurityState> mapEventToState(SecurityEvent event) async* {
    if (event is SetUpInitialValues) {
      yield state.copyWith(
        pageState: PageState.success,
        isSecurePasscode: settingsStorage.passcodeActive,
        isSecureBiometric: settingsStorage.biometricActive,
        hasNotification: false,
      );
    }
    if (event is ShowNotificationBadge) {
      yield state.copyWith(hasNotification: event.value);
    }
    if (event is OnGuardiansCardTapped) {
      yield state.copyWith(navigateToGuardians: null); //reset
      if (state.hasNotification!) {
        await FirebaseDatabaseService().removeGuardianNotification(settingsStorage.accountName);
      }
      yield state.copyWith(navigateToGuardians: true);
    }
    if (event is OnPasscodeChanged) {
      if (state.isSecurePasscode!) {
        yield state.copyWith(isSecurePasscode: false, isSecureBiometric: false);
        _authenticationBloc.add(const DisablePasscode());
      } else {
        yield state.copyWith(isSecurePasscode: true);
      }
    }
    if (event is OnBiometricsChanged) {
      if (state.isSecureBiometric!) {
        yield state.copyWith(isSecureBiometric: false);
        _authenticationBloc.add(const DisableBiometric());
      } else {
        yield state.copyWith(isSecureBiometric: true);
        _authenticationBloc.add(const EnableBiometric());
      }
    }
  }

  @override
  Future<void> close() {
    _hasGuardianNotificationPending?.cancel();
    return super.close();
  }
}
