import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

enum CurrentChoice { passcodeCard, biometricCard }

/// STATE
class SecurityState extends Equatable {
  final PageState pageState;
  final bool? hasNotification;
  final bool? navigateToGuardians;
  final bool? navigateToVerification;
  final CurrentChoice? currentChoice;
  final bool? isSecurePasscode;
  final bool? isSecureBiometric;
  final String? errorMessage;

  const SecurityState({
    required this.pageState,
    this.hasNotification,
    this.navigateToGuardians,
    this.navigateToVerification,
    this.currentChoice,
    this.isSecurePasscode,
    this.isSecureBiometric,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        hasNotification,
        navigateToGuardians,
        navigateToVerification,
        currentChoice,
        isSecurePasscode,
        isSecureBiometric,
        errorMessage,
      ];

  SecurityState copyWith({
    PageState? pageState,
    bool? hasNotification,
    bool? navigateToGuardians,
    bool? navigateToVerification,
    CurrentChoice? currentChoice,
    bool? isSecurePasscode,
    bool? isSecureBiometric,
    String? errorMessage,
  }) {
    return SecurityState(
      pageState: pageState ?? this.pageState,
      hasNotification: hasNotification ?? this.hasNotification,
      navigateToGuardians: navigateToGuardians,
      navigateToVerification: navigateToVerification,
      currentChoice: currentChoice ?? currentChoice,
      isSecurePasscode: isSecurePasscode ?? this.isSecurePasscode,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SecurityState.initial() {
    return const SecurityState(pageState: PageState.initial);
  }
}
