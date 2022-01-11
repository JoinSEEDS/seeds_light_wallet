import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/interactor/mappers/verification_status_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/usecases/initialize_biometric_authentication_use_case.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final SecurityBloc? securityBloc;
  final AuthenticationBloc authenticationBloc;

  VerificationBloc({required this.authenticationBloc, required this.securityBloc})
      : super(VerificationState.initial()) {
    on<InitBiometricAuth>(_initBiometricAuth);
    on<OnVerifyPasscode>(_onVerifyPasscode);
    on<OnCreatePasscode>((event, emit) => emit(state.copyWith(newPasscode: event.passcode)));
    on<ClearVerificationPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initBiometricAuth(InitBiometricAuth event, Emitter<VerificationState> emit) async {
    // If It's verification mode and biometric is enabled -> start biometric
    if (settingsStorage.passcode != null && settingsStorage.biometricActive!) {
      final result = await InitializeBiometricAuthenticationUseCase().run();
      emit(VerificationStatusStateMapper().mapResultToState(state, result));
      // Biometric auth result
      if (state.biometricAuthStatus == BiometricAuthStatus.authorized) {
        if (securityBloc == null) {
          if (authenticationBloc.state.isOnResumeAuth) {
            // App resume flow: disable flag and then fires navigator pop
            authenticationBloc.add(const SuccessOnResumeAuth());
            emit(state.copyWith(pageCommand: PopVerificationScreen()));
          } else {
            // Onboarding flow: just unlock
            authenticationBloc.add(const UnlockWallet());
          }
        } else {
          // Security flow: update screen and then fires navigator pop
          securityBloc?.add(const OnValidVerification());
          emit(state.copyWith(pageCommand: PopVerificationScreen()));
        }
      }
    }
  }

  void _onVerifyPasscode(OnVerifyPasscode event, Emitter<VerificationState> emit) {
    bool isValid = false;
    if (state.isCreateMode) {
      isValid = event.passcode == state.newPasscode;
    } else {
      isValid = event.passcode == settingsStorage.passcode;
    }
    if (isValid) {
      securityBloc?.add(const OnValidVerification());
      if (state.isCreateMode) {
        authenticationBloc.add(EnablePasscode(newPasscode: state.newPasscode!));
        emit(state.copyWith(pageCommand: PasscodeCreatedFromSecurity()));
        if (securityBloc == null) {
          authenticationBloc.add(const UnlockWallet());
        }
      } else {
        if (securityBloc == null) {
          if (authenticationBloc.state.isOnResumeAuth) {
            // App resume flow: disable flag and then fires navigator pop
            authenticationBloc.add(const SuccessOnResumeAuth());
            emit(state.copyWith(pageCommand: PopVerificationScreen()));
          } else {
            // Onboarding flow: just unlock
            authenticationBloc.add(const UnlockWallet());
          }
        } else {
          // pop from disable on security
          emit(state.copyWith(pageCommand: PopVerificationScreen()));
        }
      }
    } else {
      emit(state.copyWith(pageCommand: PasscodeNotMatch()));
    }
  }
}
