import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class CreateUsernameState extends Equatable {
  final PageState pageState;
  final bool isValidUsername;

  const CreateUsernameState({required this.pageState, required this.isValidUsername});

  @override
  List<Object?> get props => [pageState, isValidUsername];

  CreateUsernameState copyWith({
    PageState? pageState,
    bool? isValidUsername,
  }) {
    return CreateUsernameState(
      pageState: pageState ?? this.pageState,
      isValidUsername: isValidUsername ?? this.isValidUsername,
    );
  }

  factory CreateUsernameState.initial() {
    return const CreateUsernameState(
      pageState: PageState.initial,
      isValidUsername: false,
    );
  }
}
