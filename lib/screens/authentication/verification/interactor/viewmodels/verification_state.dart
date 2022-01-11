part of 'verification_bloc.dart';

class VerificationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final bool isCreateMode;
  final String? newPasscode;
  final BiometricAuthStatus biometricAuthStatus;
  final bool authErrorCode;

  const VerificationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.isCreateMode,
    this.newPasscode,
    required this.biometricAuthStatus,
    required this.authErrorCode,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        isCreateMode,
        newPasscode,
        biometricAuthStatus,
        authErrorCode,
      ];

  String get passcodeTitle {
    if (isCreateMode && newPasscode == null) {
      return 'Create Pincode';
    } else {
      return isCreateMode ? 'Re-enter Pincode' : 'Enter Pincode';
    }
  }

  bool get showTryAgainBiometric => !authErrorCode && settingsStorage.biometricActive!;

  VerificationState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    bool? isCreateMode,
    String? newPasscode,
    BiometricAuthStatus? biometricAuthStatus,
    bool? authErrorCode,
  }) {
    return VerificationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      biometricAuthStatus: biometricAuthStatus ?? this.biometricAuthStatus,
      authErrorCode: authErrorCode ?? this.authErrorCode,
    );
  }

  factory VerificationState.initial() {
    return VerificationState(
      pageState: PageState.initial,
      isCreateMode: settingsStorage.passcode == null,
      biometricAuthStatus: BiometricAuthStatus.initial,
      authErrorCode: false,
    );
  }
}

enum BiometricAuthStatus {
  initial,
  authorized,
  unauthorized,
  setupNeeded,
}
