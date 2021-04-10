import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/usecases/biometrics_availables_use_case.dart';
import 'package:seeds/v2/blocs/authentication/usecases/biometric_auth_use_case copy.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/blocs/authentication/mappers/auth_types_state_mapper.dart';
import 'package:seeds/v2/blocs/authentication/mappers/auth_state_state_mapper.dart';

/// --- BLOC
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.initial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is InitAuthStatus) {
      yield state.copyWith(authStatus: _updateStatus());
    }
    if (event is InitAuthentication) {
      final authTypesAvailable = await BiometricsAvailablesUseCase().run();
      yield AuthTypesStateMapper().mapResultToState(state, authTypesAvailable);
      if (state.preferred == AuthType.fingerprint || state.preferred == AuthType.face) {
        final authState = await BiometricAuthUseCase().run(state.preferred);
        yield AuthStateStateMapper().mapResultToState(state, authState);
      } else if (state.preferred == AuthType.nothing) {
        yield state.copyWith(authState: AuthState.setupNeeded);
      }
      if (state.authState == AuthState.authorized) {
        yield state.copyWith(authStatus: _updateStatus());
      }
    }
    if (event is TryAgainBiometric) {
      final authState = await BiometricAuthUseCase().run(state.preferred);
      yield AuthStateStateMapper().mapResultToState(state, authState);
      if (state.authState == AuthState.authorized) {
        yield state.copyWith(authStatus: _updateStatus());
      }
    }
    if (event is SetPasscodeAsPrefered) {
      yield state.copyWith(preferred: AuthType.password);
    }
    if (event is ResetPasscode) {
      settingsStorage.passcode = null;
      yield state.copyWith(authStatus: _updateStatus());
    }
    if (event is DisablePasscode) {
      settingsStorage.passcodeActive = false;
      yield state.copyWith(authStatus: _updateStatus());
      add(const InitAuthentication());
    }
    if (event is PasscodeAuthenticated) {
      yield state.copyWith(authState: AuthState.authorized);
      yield state.copyWith(authStatus: _updateStatus());
    }
  }

  AuthStatus _updateStatus() {
    AuthStatus status = state.authState == AuthState.authorized ? AuthStatus.unlocked : AuthStatus.locked;

    if ((settingsStorage.passcode == null || settingsStorage.passcodeActive == null) &&
        settingsStorage.passcodeActive) {
      status = AuthStatus.emptyPasscode;
    }

    if (status == AuthStatus.emptyPasscode && !settingsStorage.passcodeActive) {
      status = AuthStatus.locked;
    }

    if (settingsStorage.accountName == null || settingsStorage.privateKey == null) {
      status = AuthStatus.emptyAccount;
    }

    if (settingsStorage.inRecoveryMode == true) {
      status = AuthStatus.recoveryMode;
    }

    return status;
  }
}
