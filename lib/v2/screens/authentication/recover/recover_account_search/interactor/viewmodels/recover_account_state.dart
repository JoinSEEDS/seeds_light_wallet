import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool isValidUsername;
  final List<String> userGuardians;

  const RecoverAccountState({
    required this.pageState,
    this.errorMessage,
    required this.isValidUsername,
    required this.userGuardians,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, isValidUsername, userGuardians];

  RecoverAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isValidUsername,
    List<String>? userGuardians,
  }) {
    return RecoverAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isValidUsername: isValidUsername ?? this.isValidUsername,
      userGuardians: userGuardians ?? this.userGuardians,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(
      pageState: PageState.initial,
      isValidUsername: false,
      userGuardians: [],
    );
  }
}
