import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// STATE
class PasscodeState extends Equatable {
  final PageState pageState;
  final bool isCreateView;
  final bool isCreateMode;
  final String newPasscode;
  final bool isValidPasscode;
  final String errorMessage;

  const PasscodeState({
    @required this.pageState,
    this.isCreateView,
    this.isCreateMode,
    this.newPasscode,
    this.isValidPasscode,
    this.errorMessage,
  });

  @override
  List<Object> get props => [
        pageState,
        isCreateView,
        isCreateMode,
        newPasscode,
        isValidPasscode,
        errorMessage,
      ];

  PasscodeState copyWith({
    PageState pageState,
    bool isCreateView,
    bool isCreateMode,
    String newPasscode,
    bool isValidPasscode,
    String errorMessage,
  }) {
    return PasscodeState(
      pageState: pageState ?? this.pageState,
      isCreateView: isCreateView ?? this.isCreateView,
      isCreateMode: isCreateMode ?? this.isCreateMode,
      newPasscode: newPasscode ?? this.newPasscode,
      isValidPasscode: isValidPasscode ?? this.isValidPasscode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PasscodeState.initial() {
    return const PasscodeState(
      pageState: PageState.initial,
      isCreateView: null,
      isCreateMode: null,
      newPasscode: null,
      isValidPasscode: null,
      errorMessage: null,
    );
  }
}
