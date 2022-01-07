part of 'verification_bloc.dart';

class VerificationState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final bool? isCreateView;
  final bool? isCreateMode;
  final String? newPasscode;
  final bool? isValidPasscode;
  final AuthState? authState;
  final List<AuthType>? authTypesAvailable;
  final AuthType? preferred;
  final bool authError;

  const VerificationState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    this.isCreateView,
    this.isCreateMode,
    this.newPasscode,
    this.isValidPasscode,
    this.authState,
    this.authTypesAvailable,
    this.preferred,
    required this.authError,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        isCreateView,
        isCreateMode,
        newPasscode,
        isValidPasscode,
        authState,
        authTypesAvailable,
        preferred,
        authError,
      ];

  String get passcodeTitle {
    if (isCreateView!) {
      return 'Create Pincode';
    } else {
      return (isCreateMode ?? false) ? 'Re-enter Pincode' : 'Enter Pincode';
    }
  }

  bool get showTryAgainBiometric => !authError && settingsStorage.biometricActive!;

  VerificationState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    bool? isCreateView,
    bool? isCreateMode,
    String? newPasscode,
    bool? isValidPasscode,
    AuthState? authState,
    List<AuthType>? authTypesAvailable,
    AuthType? preferred,
    bool? authError,
  }) {
    return VerificationState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      isCreateView: isCreateView ?? this.isCreateView,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      isValidPasscode: isValidPasscode ?? this.isValidPasscode,
      authState: authState ?? this.authState,
      authTypesAvailable: authTypesAvailable ?? this.authTypesAvailable,
      preferred: preferred ?? this.preferred,
      authError: authError ?? this.authError,
    );
  }

  factory VerificationState.initial() {
    return const VerificationState(pageState: PageState.initial, authError: false);
  }
}
