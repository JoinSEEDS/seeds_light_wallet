import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:seeds/datasource/local/biometrics_service.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/interactor/mappers/verification_status_state_mapper.dart';
import 'package:seeds/screens/authentication/verification/interactor/usecases/initialize_biometric_authentication_use_case.dart';
import 'package:seeds/screens/authentication/verification/interactor/viewmodels/page_commands.dart';
import 'package:seeds/utils/build_context_extension.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc() : super(VerificationState.initial()) {
    on<InitBiometricAuth>(_initBiometricAuth);
    on<OnVerifyPasscode>(_onVerifyPasscode);
    on<OnPasscodeCreated>((event, emit) => emit(state.copyWith(newPasscode: event.passcode)));
    on<ClearVerificationPageCommand>((_, emit) => emit(state.copyWith()));
  }

  Future<void> _initBiometricAuth(InitBiometricAuth event, Emitter<VerificationState> emit) async {
    // If It's verification mode and biometric is enabled -> start biometric
    if (settingsStorage.passcode != null && settingsStorage.biometricActive!) {
      final result = await InitializeBiometricAuthenticationUseCase().run();
      emit(VerificationStatusStateMapper().mapResultToState(state, result));
    } else {
      emit(state.copyWith(pageState: PageState.success));
    }
  }

  void _onVerifyPasscode(OnVerifyPasscode event, Emitter<VerificationState> emit) {
    bool isValid = false;
    if (state.isCreateMode) {
      isValid = event.passcode == state.newPasscode;
    } else {
      isValid = event.passcode == settingsStorage.passcode;
    }
    emit(state.copyWith(pageCommand: isValid ? PasscodeValid() : PasscodeNotMatch()));
  }
}
