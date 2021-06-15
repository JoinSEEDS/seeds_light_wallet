import 'package:bloc/bloc.dart';
import 'package:seeds/v2/blocs/authentication/viewmodels/bloc.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/features/biometrics/auth_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/mappers/auth_state_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/mappers/auth_types_state_mapper.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/usecases/biometric_auth_use_case%20copy.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/usecases/biometrics_availables_use_case.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/viewmodels/verification_event.dart';
import 'package:seeds/v2/screens/authentication/verification/interactor/viewmodels/verification_state.dart';
import 'package:seeds/v2/screens/profile_screens/security/interactor/viewmodels/bloc.dart';

/// --- BLOC
class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  final SecurityBloc? securityBloc;
  final AuthenticationBloc authenticationBloc;

  VerificationBloc({required this.authenticationBloc, required this.securityBloc}) : super(VerificationState.initial());

  @override
  Stream<VerificationState> mapEventToState(VerificationEvent event) async* {
    if (event is InitVerification) {
      // Define passcode view and mode
      yield state.copyWith(
        pageState: PageState.success,
        isCreateView: settingsStorage.passcode == null,
        isCreateMode: settingsStorage.passcode == null,
      );
      // If It's verification mode and biometric is enabled -> start biometric
      if (settingsStorage.passcode != null && settingsStorage.biometricActive!) {
        // Fecht available biometrics
        final authTypesAvailable = await BiometricsAvailablesUseCase().run();
        yield AuthTypesStateMapper().mapResultToState(state, authTypesAvailable);
        // If fingerprint or face start biometric auth
        if (state.preferred == AuthType.fingerprint || state.preferred == AuthType.face) {
          final authState = await BiometricAuthUseCase().run(state.preferred!);
          yield AuthStateStateMapper().mapResultToState(state, authState);
        }
        // Biometric auth result
        if (state.authState == AuthState.authorized) {
          if (securityBloc == null) {
            if (authenticationBloc.state.isOnResumeAuth) {
              // App resume flow: disable flag and then fires navigator pop
              authenticationBloc.add(const SuccessOnResumeAuth());
              yield state.copyWith(popScreen: true);
            } else {
              // Onboarding flow: just unlock
              authenticationBloc.add(const UnlockWallet());
            }
          } else {
            // Security flow: update screen and then fires navigator pop
            securityBloc?.add(const OnValidVerification());
            yield state.copyWith(popScreen: true);
          }
        }
      }
    }
    if (event is OnVerifyPasscode) {
      if (state.isCreateMode!) {
        yield state.copyWith(
          isValidPasscode: event.passcode == state.newPasscode,
          showInfoSnack: event.passcode == state.newPasscode ? null : true,
        );
      } else {
        yield state.copyWith(
          isValidPasscode: event.passcode == settingsStorage.passcode,
          showInfoSnack: event.passcode == settingsStorage.passcode ? null : true,
        );
      }
    }
    if (event is OnValidVerifyPasscode) {
      securityBloc?.add(const OnValidVerification());
      if (state.isCreateMode!) {
        authenticationBloc.add(EnablePasscode(newPasscode: state.newPasscode!));
        yield state.copyWith(showSuccessDialog: true);
        if (securityBloc == null) {
          authenticationBloc.add(const UnlockWallet());
        }
      } else {
        if (securityBloc == null) {
          if (authenticationBloc.state.isOnResumeAuth) {
            // App resume flow: disable flag and then fires navigator pop
            authenticationBloc.add(const SuccessOnResumeAuth());
            yield state.copyWith(popScreen: true);
          } else {
            // Onboarding flow: just unlock
            authenticationBloc.add(const UnlockWallet());
          }
        }
      }
    }
    if (event is OnCreatePasscode) {
      yield state.copyWith(isCreateView: false, newPasscode: event.passcode);
    }
    if (event is ResetShowSnack) {
      yield state.copyWith(showInfoSnack: null);
    }
    if (event is TryAgainBiometric) {
      if (state.preferred == AuthType.fingerprint || state.preferred == AuthType.face) {
        // If fingerprint or face start biometric auth
        final authState = await BiometricAuthUseCase().run(state.preferred!);
        yield AuthStateStateMapper().mapResultToState(state, authState);
        // Biometric auth result
        if (state.authState == AuthState.authorized) {
          if (securityBloc == null) {
            if (authenticationBloc.state.isOnResumeAuth) {
              // App resume flow: disable flag and then fires navigator pop
              authenticationBloc.add(const SuccessOnResumeAuth());
              yield state.copyWith(popScreen: true);
            } else {
              // Onboarding flow: just unlock
              authenticationBloc.add(const UnlockWallet());
            }
          } else {
            // Security flow: update screen and then fires navigator pop
            securityBloc?.add(const OnValidVerification());
            yield state.copyWith(popScreen: true);
          }
        }
      }
    }
  }
}
