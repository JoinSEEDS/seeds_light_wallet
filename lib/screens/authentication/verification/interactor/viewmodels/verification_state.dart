part of 'verification_bloc.dart';

enum PassCodeTitle { createPinCode, reEnterPinCode, enterPinCode }

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

  PassCodeTitle get passcodeTitle {
    if (isCreateMode && newPasscode == null) {
      return PassCodeTitle.createPinCode;
    } else {
      return isCreateMode ? PassCodeTitle.reEnterPinCode : PassCodeTitle.enterPinCode;
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

extension LocalizedPasCodeTitle on PassCodeTitle {
  String localizedDescription(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    switch (this) {
      case PassCodeTitle.createPinCode:
        return localization.verificationScreenCreateCode;
      case PassCodeTitle.reEnterPinCode:
        return localization.verificationScreenReEnterCode;
      case PassCodeTitle.enterPinCode:
        return localization.verificationScreenEnterCode;
    }
  }
}
