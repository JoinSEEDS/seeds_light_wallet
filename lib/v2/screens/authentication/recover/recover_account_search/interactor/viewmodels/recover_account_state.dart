import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class RecoverAccountState extends Equatable {
  final PageState pageState;
  final bool isValidUsername;
  final String? errorMessage;

  const RecoverAccountState({required this.pageState, required this.isValidUsername, this.errorMessage});

  @override
  List<Object?> get props => [pageState, isValidUsername, errorMessage];

  RecoverAccountState copyWith({
    PageState? pageState,
    bool? isValidUsername,
    String? errorMessage,
  }) {
    return RecoverAccountState(
        pageState: pageState ?? this.pageState,
        isValidUsername: isValidUsername ?? this.isValidUsername,
        errorMessage: errorMessage);
  }

  factory RecoverAccountState.initial() {
    return const RecoverAccountState(pageState: PageState.initial, isValidUsername: false);
  }
}
