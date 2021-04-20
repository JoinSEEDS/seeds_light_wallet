import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/mappers/auth_status_state_mapper.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';

/// --- BLOC
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.initial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is InitAuthStatus) {
      yield AuthStatusStateMapper().mapResultToState(state);
    }
    if (event is UnlockWallet) {
      yield state.copyWith(authStatus: AuthStatus.unlocked);
    }
    if (event is OnImportAccount) {
      settingsStorage.saveAccount(event.account, event.privateKey);
      settingsStorage.privateKeyBackedUp = true;
      // New account --> re-start auth status
      add(const InitAuthStatus());
    }
    if (event is EnablePasscode) {
      settingsStorage.savePasscode(event.newPasscode);
      settingsStorage.passcodeActive = true;
    }
    if (event is DisablePasscode) {
      settingsStorage.passcode = null;
      settingsStorage.passcodeActive = false;
      settingsStorage.biometricActive = false;
    }
    if (event is EnableBiometric) {
      settingsStorage.biometricActive = true;
    }
    if (event is DisableBiometric) {
      settingsStorage.biometricActive = false;
    }
  }
}
