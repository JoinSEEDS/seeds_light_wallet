import 'package:bloc/bloc.dart';
import 'package:seeds/blocs/authentication/mappers/auth_status_state_mapper.dart';
import 'package:seeds/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/remove_account_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_account_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/switch_account_use_case.dart';

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
    if (event is OnInviteLinkRecived) {
      yield state.copyWith(authStatus: AuthStatus.inviteLink);
    }
    if (event is OnCreateAccount) {
      await SaveAccountUseCase().run(accountName: event.account, authData: event.authData);
      // New account --> re-start auth status
      add(const InitAuthStatus());
    }
    if (event is OnImportAccount) {
      await SaveAccountUseCase().run(accountName: event.account, authData: event.authData);
      // New account --> re-start auth status
      add(const InitAuthStatus());
    }
    if (event is OnRecoverAccount) {
      settingsStorage.finishRecoveryProcess();
      // Recovered account --> re-start auth status
      add(const InitAuthStatus());
    }
    if (event is OnSwitchAccount) {
      SwitchAccountUseCase().run(event.account, event.authData);
      // New account --> re-start auth status
      add(const InitAuthStatus());
    }
    if (event is EnablePasscode) {
      settingsStorage.enablePasscode(event.newPasscode);
    }
    if (event is DisablePasscode) {
      settingsStorage.disablePasscode();
    }
    if (event is EnableBiometric) {
      settingsStorage.biometricActive = true;
    }
    if (event is DisableBiometric) {
      settingsStorage.biometricActive = false;
    }
    if (event is OnLogout) {
      // Clear data
      await RemoveAccountUseCase().run();
      // User logout --> re-start auth status
      add(const InitAuthStatus());
    }
  }
}
