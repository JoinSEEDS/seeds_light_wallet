import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class CreateUsernameState extends Equatable {
  final PageState pageState;
  final bool isValidUsername;
  final int usernameCharCount;

  const CreateUsernameState({@required this.pageState, this.isValidUsername, this.usernameCharCount});

  @override
  List<Object> get props => [pageState, isValidUsername, usernameCharCount];

  CreateUsernameState copyWith({
    PageState pageState,
    bool isValidUsername,
    int usernameCharCount,
  }) {
    return CreateUsernameState(
        pageState: pageState ?? this.pageState,
        isValidUsername: isValidUsername ?? this.isValidUsername,
        usernameCharCount: usernameCharCount ?? this.usernameCharCount);
  }

  factory CreateUsernameState.initial() {
    return const CreateUsernameState(
      pageState: PageState.initial,
      isValidUsername: false,
      usernameCharCount: 0,
    );
  }
}
