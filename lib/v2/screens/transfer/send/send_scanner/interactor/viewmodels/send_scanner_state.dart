import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class SendPageState extends Equatable {
  final PageState pageState;
  final String? error;
  final PageCommand? pageCommand;

  const SendPageState({required this.pageState, this.error, this.pageCommand});

  @override
  List<Object> get props => [pageState];

  SendPageState copyWith({PageState? pageState, String? error, PageCommand? pageCommand}) {
    return SendPageState(
        pageState: pageState ?? this.pageState,
        error: error ?? this.error,
        pageCommand: pageCommand ?? this.pageCommand);
  }

  factory SendPageState.initial() {
    return const SendPageState(pageState: PageState.initial);
  }
}
