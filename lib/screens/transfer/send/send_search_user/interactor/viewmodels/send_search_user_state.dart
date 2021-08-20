import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

class SendSearchUserPageState extends Equatable {
  final PageState pageState;
  final String? errorMessage;

  const SendSearchUserPageState({required this.pageState, this.errorMessage});

  @override
  List<Object> get props => [pageState];

  SendSearchUserPageState copyWith({PageState? pageState, String? errorMessage}) {
    return SendSearchUserPageState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
    );
  }

  factory SendSearchUserPageState.initial() {
    return const SendSearchUserPageState(pageState: PageState.initial);
  }
}
