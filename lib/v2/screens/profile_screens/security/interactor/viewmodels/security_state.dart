import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

enum CurrentChoice { initial, passcodeCard, biometricCard }

/// STATE
class SecurityState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool hasNotification;
  final bool? navigateToGuardians;
  final bool? navigateToVerification;
  final CurrentChoice currentChoice;
  final bool? isSecurePasscode;
  final bool? isSecureBiometric;

  const SecurityState({
    required this.pageState,
    this.errorMessage,
    required this.hasNotification,
    this.navigateToGuardians,
    this.navigateToVerification,
    required this.currentChoice,
    this.isSecurePasscode,
    this.isSecureBiometric,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        hasNotification,
        navigateToGuardians,
        navigateToVerification,
        currentChoice,
        isSecurePasscode,
        isSecureBiometric,
      ];

  SecurityState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? hasNotification,
    bool? navigateToGuardians,
    bool? navigateToVerification,
    CurrentChoice? currentChoice,
    bool? isSecurePasscode,
    bool? isSecureBiometric,
  }) {
    return SecurityState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      hasNotification: hasNotification ?? this.hasNotification,
      navigateToGuardians: navigateToGuardians,
      navigateToVerification: navigateToVerification,
      currentChoice: currentChoice ?? this.currentChoice,
      isSecurePasscode: isSecurePasscode ?? this.isSecurePasscode,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
    );
  }

  factory SecurityState.initial() {
    return const SecurityState(
      pageState: PageState.initial,
      currentChoice: CurrentChoice.initial,
      hasNotification: false,
    );
  }
}
