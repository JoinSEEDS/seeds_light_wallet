import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class AddPhoneNumberState extends Equatable {
  const AddPhoneNumberState({
    required this.pageState,
    this.errorMessage,
  });

  final PageState pageState;
  final String? errorMessage;

  factory AddPhoneNumberState.initial() {
    return const AddPhoneNumberState(pageState: PageState.initial);
  }

  factory AddPhoneNumberState.loading(AddPhoneNumberState currentState) =>
      currentState.copyWith(pageState: PageState.loading, errorMessage: null);

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
      ];

  AddPhoneNumberState copyWith({
    PageState? pageState,
    String? errorMessage,
  }) =>
      AddPhoneNumberState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
