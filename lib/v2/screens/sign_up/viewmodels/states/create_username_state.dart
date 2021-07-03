import 'package:equatable/equatable.dart';
import 'package:seeds/utils/string_extension.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class UsernameGenerated extends PageCommand {}

class CreateUsernameState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? username;
  final String? errorMessage;

  const CreateUsernameState({
    required this.pageState,
    this.pageCommand,
    this.username,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [pageState, username, errorMessage];

  CreateUsernameState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? username,
    String? errorMessage,
  }) {
    return CreateUsernameState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand ?? this.pageCommand,
      username: username ?? this.username,
      errorMessage: errorMessage,
    );
  }

  factory CreateUsernameState.initial() {
    return const CreateUsernameState(
      pageState: PageState.initial,
      username: null,
    );
  }

  factory CreateUsernameState.loading(CreateUsernameState currentState) {
    return currentState.copyWith(pageState: PageState.loading, errorMessage: null);
  }

  factory CreateUsernameState.error(CreateUsernameState currentState, String errorMessage) {
    return currentState.copyWith(
      pageState: PageState.failure,
      errorMessage: errorMessage,
    );
  }

  bool get isUsernameValid => !username.isNullOrEmpty && pageState == PageState.success;

  bool get isNextButtonActive => isUsernameValid;
}
