import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class SecurityState extends Equatable {
  final PageState pageState;
  final bool hasNotification;
  final bool navigateToGuardians;
  final bool isSecurePin;
  final bool isSecureBiometric;
  final String errorMessage;

  const SecurityState({
    @required this.pageState,
    this.hasNotification,
    this.navigateToGuardians,
    this.isSecurePin,
    this.isSecureBiometric,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        hasNotification,
        navigateToGuardians,
        isSecurePin,
        isSecureBiometric,
        errorMessage,
      ];

  SecurityState copyWith({
    PageState pageState,
    bool hasNotification,
    bool navigateToGuardians,
    bool isSecurePin,
    bool isSecureBiometric,
    String errorMessage,
  }) {
    return SecurityState(
      pageState: pageState ?? this.pageState,
      hasNotification: hasNotification ?? this.hasNotification,
      navigateToGuardians: navigateToGuardians ?? this.navigateToGuardians,
      isSecurePin: isSecurePin ?? this.isSecurePin,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SecurityState.initial() {
    return const SecurityState(
      pageState: PageState.success,
      hasNotification: false,
      navigateToGuardians: false,
      isSecurePin: false,
      isSecureBiometric: false,
      errorMessage: null,
    );
  }
}
