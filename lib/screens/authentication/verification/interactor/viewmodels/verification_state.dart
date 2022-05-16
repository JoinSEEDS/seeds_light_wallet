part of 'verification_bloc.dart';

enum PasscodeTitle {
  createPinCode,
  reEnterPinCode,
  enterPinCode;

  String localizedDescription(BuildContext context) {
    switch (this) {
      case PasscodeTitle.createPinCode:
        return context.loc.verificationScreenCreateCode;
      case PasscodeTitle.reEnterPinCode:
        return context.loc.verificationScreenReEnterCode;
      case PasscodeTitle.enterPinCode:
        return context.loc.verificationScreenEnterCode;
    }
  }
}

class VerificationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final bool isCreateMode;
  final String? newPasscode;
  final BiometricAuthStatus biometricAuthStatus;
  final bool biometricAuthError;

  const VerificationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.isCreateMode,
    this.newPasscode,
    required this.biometricAuthStatus,
    required this.biometricAuthError,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        isCreateMode,
        newPasscode,
        biometricAuthStatus,
        biometricAuthError,
      ];

  PasscodeTitle get passcodeTitle {
    if (isCreateMode && newPasscode == null) {
      return PasscodeTitle.createPinCode;
    } else {
      return isCreateMode ? PasscodeTitle.reEnterPinCode : PasscodeTitle.enterPinCode;
    }
  }

  bool get showTryAgainBiometric => !biometricAuthError && settingsStorage.biometricActive!;

  VerificationState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    bool? isCreateMode,
    String? newPasscode,
    BiometricAuthStatus? biometricAuthStatus,
    bool? biometricAuthError,
  }) {
    return VerificationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      biometricAuthStatus: biometricAuthStatus ?? this.biometricAuthStatus,
      biometricAuthError: biometricAuthError ?? this.biometricAuthError,
    );
  }

  factory VerificationState.initial() {
    return VerificationState(
      pageState: PageState.initial,
      isCreateMode: settingsStorage.passcode == null,
      biometricAuthStatus: BiometricAuthStatus.initial,
      biometricAuthError: false,
    );
  }
}
