import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/authentication/mappers/auth_status_state_mapper.dart';
import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/firebase/firebase_message_token_repository.dart';

/// --- BLOC
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.initial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is InitAuthStatus) {
      yield AuthStatusStateMapper().mapResultToState(state);
    }
    if (event is InitOnResumeAuth) {
      yield state.copyWith(isOnResumeAuth: true);
    }
    if (event is SuccessOnResumeAuth) {
      yield state.copyWith(isOnResumeAuth: false);
    }
    if (event is UnlockWallet) {
      yield state.copyWith(authStatus: AuthStatus.unlocked);
    }
    if (event is OnImportAccount) {
      settingsStorage.saveAccount(event.account, event.privateKey);
      settingsStorage.inRecoveryMode = false; // clear recovery flag - new account was imported.
      settingsStorage.privateKeyBackedUp = true;
      // New account --> re-start auth status
      add(const InitAuthStatus());
      // Set fcm token must be last instruction to allow login, even if there is an error here.
      await FirebaseMessageTokenRepository().setFirebaseMessageToken(event.account);
    }
    if (event is OnCreateAccount) {
      // New account --> re-start auth status
      add(const InitAuthStatus());
      // Set fcm token must be last instruction to allow login, even if there is an error here.
      await FirebaseMessageTokenRepository().setFirebaseMessageToken(settingsStorage.accountName);
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
    if (event is OnLogout) {
      // copy account before clear data
      final account = settingsStorage.accountName;
      // Clear data
      settingsStorage.removeAccount();
      // User logout --> re-start auth status
      add(const InitAuthStatus());
      // Remove fcm token must be last instruction to allow logout, even if there is an error here.
      await FirebaseMessageTokenRepository().removeFirebaseMessageToken(account);
    }
  }
}
