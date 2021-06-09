import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class CreateUsernameState extends Equatable {
  final PageState pageState;
  final String? username;
  final bool isValidUsername;

  const CreateUsernameState({
    required this.pageState,
    required this.isValidUsername,
    this.username,
  });

  @override
  List<Object?> get props => [pageState, isValidUsername];

  CreateUsernameState copyWith({
    PageState? pageState,
    String? username,
    bool? isValidUsername,
  }) {
    return CreateUsernameState(
      pageState: pageState ?? this.pageState,
      username: username ?? this.username,
      isValidUsername: isValidUsername ?? this.isValidUsername,
    );
  }

  factory CreateUsernameState.initial() {
    return const CreateUsernameState(
      pageState: PageState.initial,
      username: null,
      isValidUsername: false,
    );
  }
}
