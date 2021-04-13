import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/features/biometrics/auth_type.dart';
import 'package:seeds/features/biometrics/auth_state.dart';

/// STATE
class VerificationState extends Equatable {
  final PageState pageState;
  final bool isCreateView;
  final bool isCreateMode;
  final String newPasscode;
  final bool isValidPasscode;
  final bool showInfoSnack;
  final AuthState authState;
  final List<AuthType> authTypesAvailable;
  final AuthType preferred;
  final bool onBiometricAuthorized;
  final String errorMessage;

  const VerificationState({
    @required this.pageState,
    this.isCreateView,
    this.isCreateMode,
    this.newPasscode,
    this.isValidPasscode,
    this.showInfoSnack,
    this.authState,
    this.authTypesAvailable,
    this.preferred,
    this.onBiometricAuthorized,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        isCreateView,
        isCreateMode,
        newPasscode,
        isValidPasscode,
        showInfoSnack,
        authState,
        authTypesAvailable,
        preferred,
        errorMessage,
      ];

  VerificationState copyWith({
    PageState pageState,
    bool isCreateView,
    bool isCreateMode,
    String newPasscode,
    bool isValidPasscode,
    bool showInfoSnack,
    AuthState authState,
    List<AuthType> authTypesAvailable,
    AuthType preferred,
    bool onBiometricAuthorized,
    String errorMessage,
  }) {
    return VerificationState(
      pageState: pageState ?? this.pageState,
      isCreateView: isCreateView ?? this.isCreateView,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      isValidPasscode: isValidPasscode ?? this.isValidPasscode,
      showInfoSnack: showInfoSnack,
      authState: authState ?? this.authState,
      authTypesAvailable: authTypesAvailable ?? this.authTypesAvailable,
      preferred: preferred ?? this.preferred,
      onBiometricAuthorized: onBiometricAuthorized ?? this.onBiometricAuthorized,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory VerificationState.initial() {
    return const VerificationState(pageState: PageState.initial);
  }
}
