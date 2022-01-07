import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/authentication/viewmodels/authentication_bloc.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/interactor/mappers/auth_state_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/mappers/auth_types_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_state.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_type.dart';
import 'package:seeds/screens/authentication/verification/interactor/usecases/biometric_auth_use_case.dart';
import 'package:seeds/screens/authentication/verification/interactor/usecases/biometrics_availables_use_case.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/screens/profile_screens/security/interactor/viewmodels/security_bloc.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final SecurityBloc? securityBloc;
  final AuthenticationBloc authenticationBloc;

  VerificationBloc({required this.authenticationBloc, required this.securityBloc})
      : super(VerificationState.initial()) {
    on<InitVerification>(_initVerification);
    on<OnVerifyPasscode>(_onVerifyPasscode);
    on<OnValidVerifyPasscode>(_onValidVerifyPasscode);
    on<OnCreatePasscode>(_onCreatePasscode);
    on<ClearVerificationPageCommand>((_, emit) => emit(state.copyWith()));
    on<TryAgainBiometric>(_tryAgainBiometric);
  }

  Future<void> _initVerification(InitVerification event, Emitter<VerificationState> emit) async {
    // Define passcode view and mode
    emit(state.copyWith(
      pageState: PageState.success,
      isCreateView: settingsStorage.passcode == null,
      isCreateMode: settingsStorage.passcode == null,
    ));
    // If It's verification mode and biometric is enabled -> start biometric
    if (settingsStorage.passcode != null && settingsStorage.biometricActive!) {
      // Fecht available biometrics
      final authTypesAvailable = await BiometricsAvailablesUseCase().run();
      emit(AuthTypesStateMapper().mapResultToState(state, authTypesAvailable));
      // If fingerprint or face start biometric auth
      if (state.preferred == AuthType.fingerprint || state.preferred == AuthType.face) {
        final authState = await BiometricAuthUseCase().run(state.preferred!);
        emit(AuthStateStateMapper().mapResultToState(state, authState));
      }
      // Biometric auth result
      if (state.authState == AuthState.authorized) {
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
    if (state.isCreateMode!) {
      emit(state.copyWith(
        isValidPasscode: event.passcode == state.newPasscode,
        pageCommand: event.passcode == state.newPasscode ? null : PasscodeNotMatch(),
      ));
    } else {
      emit(state.copyWith(
        isValidPasscode: event.passcode == settingsStorage.passcode,
        pageCommand: event.passcode == settingsStorage.passcode ? null : PasscodeNotMatch(),
      ));
    }
    if (state.isValidPasscode ?? false) {
      add(const OnValidVerifyPasscode());
    }
  }

  void _onValidVerifyPasscode(OnValidVerifyPasscode event, Emitter<VerificationState> emit) {
    securityBloc?.add(const OnValidVerification());
    if (state.isCreateMode!) {
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
  }

  void _onCreatePasscode(OnCreatePasscode event, Emitter<VerificationState> emit) {
    emit(state.copyWith(isCreateView: false, newPasscode: event.passcode));
  }

  Future<void> _tryAgainBiometric(TryAgainBiometric event, Emitter<VerificationState> emit) async {
    if (state.preferred == AuthType.fingerprint || state.preferred == AuthType.face) {
      // If fingerprint or face start biometric auth
      final authState = await BiometricAuthUseCase().run(state.preferred!);
      emit(AuthStateStateMapper().mapResultToState(state, authState));
      // Biometric auth result
      if (state.authState == AuthState.authorized) {
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
}
