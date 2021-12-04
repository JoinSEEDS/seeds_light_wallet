import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/mappers/auth_status_state_mapper.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/shared_use_cases/remove_account_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/save_account_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/stop_recovery_use_case.dart';
import 'package:seeds/domain-shared/shared_use_cases/switch_account_use_case.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationState.initial()) {
    on<InitAuthStatus>((_, emit) => emit(AuthStatusStateMapper().mapResultToState(state)));
    on<InitOnResumeAuth>((_, emit) => emit(state.copyWith(isOnResumeAuth: true)));
    on<SuccessOnResumeAuth>((_, emit) => emit(state.copyWith(isOnResumeAuth: false)));
    on<UnlockWallet>((_, emit) => emit(state.copyWith(authStatus: AuthStatus.unlocked)));
    on<OnInviteLinkRecived>((_, emit) => emit(state.copyWith(authStatus: AuthStatus.inviteLink)));
    on<OnCreateAccount>(_onCreateAccount);
    on<OnImportAccount>(_onImportAccount);
    on<OnRecoverAccount>(_onRecoverAccount);
    on<OnSwitchAccount>(_onSwitchAccount);
    on<EnablePasscode>((event, _) => settingsStorage.enablePasscode(event.newPasscode));
    on<DisablePasscode>((_, __) => settingsStorage.disablePasscode());
    on<EnableBiometric>((_, __) => settingsStorage.biometricActive = true);
    on<DisableBiometric>((_, __) => settingsStorage.biometricActive = false);
    on<OnLogout>(_onLogout);
  }

  Future<void> _onCreateAccount(OnCreateAccount event, Emitter<AuthenticationState> emit) async {
    /// In case there was a recovery in place. We cancel it.
    /// This will clean all data
    await StopRecoveryUseCase().run();
    await SaveAccountUseCase().run(accountName: event.account, authData: event.authData);
    // New account --> re-start auth status
    add(const InitAuthStatus());
  }

  Future<void> _onImportAccount(OnImportAccount event, Emitter<AuthenticationState> emit) async {
    /// Cancel recover should not be executed on switch account (app unlocked).
    /// Since cancel recover removes preferences and secure storage.
    if (state.authStatus != AuthStatus.unlocked) {
      /// In case there was a recovery in place. We cancel it.
      /// This will clean all data
      await StopRecoveryUseCase().run();
    }
    await SaveAccountUseCase().run(accountName: event.account, authData: event.authData);
    // New account --> re-start auth status
    add(const InitAuthStatus());
  }

  void _onRecoverAccount(OnRecoverAccount event, Emitter<AuthenticationState> emit) {
    settingsStorage.finishRecoveryProcess();
    // Recovered account --> re-start auth status
    add(const InitAuthStatus());
  }

  void _onSwitchAccount(OnSwitchAccount event, Emitter<AuthenticationState> emit) {
    SwitchAccountUseCase().run(event.account, event.authData);
    // New account --> re-start auth status
    add(const InitAuthStatus());
  }

  Future<void> _onLogout(OnLogout event, Emitter<AuthenticationState> emit) async {
    // Clear data
    await RemoveAccountUseCase().run();
    // User logout --> re-start auth status
    add(const InitAuthStatus());
  }
}
