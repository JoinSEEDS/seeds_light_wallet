import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_type.dart';
import 'package:seeds/screens/authentication/verification/interactor/model/auth_state.dart';

/// STATE
class VerificationState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool? isCreateView;
  final bool? isCreateMode;
  final String? newPasscode;
  final bool? isValidPasscode;
  final bool? showInfoSnack;
  final AuthState? authState;
  final List<AuthType>? authTypesAvailable;
  final AuthType? preferred;
  final bool? authError;
  final bool? popScreen;
  final bool? showSuccessDialog;

  const VerificationState({
    required this.pageState,
    this.errorMessage,
    this.isCreateView,
    this.isCreateMode,
    this.newPasscode,
    this.isValidPasscode,
    this.showInfoSnack,
    this.authState,
    this.authTypesAvailable,
    this.preferred,
    this.authError,
    this.popScreen,
    this.showSuccessDialog,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        isCreateView,
        isCreateMode,
        newPasscode,
        isValidPasscode,
        showInfoSnack,
        authState,
        authTypesAvailable,
        preferred,
        authError,
        popScreen,
        showSuccessDialog,
      ];

  VerificationState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isCreateView,
    bool? isCreateMode,
    String? newPasscode,
    bool? isValidPasscode,
    bool? showInfoSnack,
    AuthState? authState,
    List<AuthType>? authTypesAvailable,
    AuthType? preferred,
    bool? authError,
    bool? popScreen,
    bool? showSuccessDialog,
  }) {
    return VerificationState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isCreateView: isCreateView ?? this.isCreateView,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      isValidPasscode: isValidPasscode ?? this.isValidPasscode,
      showInfoSnack: showInfoSnack,
      authState: authState ?? this.authState,
      authTypesAvailable: authTypesAvailable ?? this.authTypesAvailable,
      preferred: preferred ?? this.preferred,
      authError: authError ?? this.authError,
      popScreen: popScreen ?? this.popScreen,
      showSuccessDialog: showSuccessDialog ?? this.showSuccessDialog,
    );
  }

  factory VerificationState.initial() {
    return const VerificationState(pageState: PageState.initial, authError: false);
  }
}
