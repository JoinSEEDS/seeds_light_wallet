import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final bool isValidUsername;

  const RecoverAccountState({
    required this.pageState,
    this.errorMessage,
    required this.isValidUsername,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, isValidUsername];

  RecoverAccountState copyWith({
    PageState? pageState,
    String? errorMessage,
    bool? isValidUsername,
  }) {
    return RecoverAccountState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      isValidUsername: isValidUsername ?? this.isValidUsername,
    );
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(pageState: PageState.initial, isValidUsername: false);
  }
}
