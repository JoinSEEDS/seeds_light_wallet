import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendSearchUserPageState extends Equatable {
  final PageState pageState;
  final String? error;

  const SendSearchUserPageState({required this.pageState, this.error});

  @override
  List<Object> get props => [pageState];

  SendSearchUserPageState copyWith({PageState? pageState, String? error}) {
    return SendSearchUserPageState(pageState: pageState ?? this.pageState, error: error ?? this.error);
  }

  factory SendSearchUserPageState.initial() {
    return const SendSearchUserPageState(pageState: PageState.initial);
  }
}
