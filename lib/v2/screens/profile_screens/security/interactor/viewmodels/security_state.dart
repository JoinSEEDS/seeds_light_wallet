import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class SecurityState extends Equatable {
  final PageState pageState;
  final bool isSecurePin;
  final bool isSecureBiometric;
  final String errorMessage;

  const SecurityState({
    @required this.pageState,
    this.isSecurePin,
    this.isSecureBiometric,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        isSecurePin,
        isSecureBiometric,
        errorMessage,
      ];

  SecurityState copyWith({
    PageState pageState,
    bool isSecurePin,
    bool isSecureBiometric,
    String errorMessage,
  }) {
    return SecurityState(
      pageState: pageState ?? this.pageState,
      isSecurePin: isSecurePin ?? this.isSecurePin,
      isSecureBiometric: isSecureBiometric ?? this.isSecureBiometric,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SecurityState.initial() {
    return const SecurityState(
      pageState: PageState.success,
      isSecurePin: false,
      isSecureBiometric: false,
      errorMessage: null,
    );
  }
}
