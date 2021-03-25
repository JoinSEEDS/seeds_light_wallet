import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class PasscodeState extends Equatable {
  final PageState pageState;
  final bool isCreateView;
  final bool isValidPasscode;
  final String errorMessage;

  const PasscodeState({
    @required this.pageState,
    this.isCreateView,
    this.isValidPasscode,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        isCreateView,
        isValidPasscode,
        errorMessage,
      ];

  PasscodeState copyWith({
    PageState pageState,
    bool isCreateView,
    bool isValidPasscode,
    String errorMessage,
  }) {
    return PasscodeState(
      pageState: pageState ?? this.pageState,
      isCreateView: isCreateView ?? this.isCreateView,
      isValidPasscode: isValidPasscode ?? this.isValidPasscode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PasscodeState.initial() {
    return const PasscodeState(
      pageState: PageState.success,
      isCreateView: false,
      isValidPasscode: false,
      errorMessage: null,
    );
  }
}
