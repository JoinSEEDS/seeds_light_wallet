import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class SendPageState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;

  const SendPageState({required this.pageState, this.pageCommand, this.errorMessage});

  @override
  List<Object> get props => [pageState];

  SendPageState copyWith({PageState? pageState, PageCommand? pageCommand, String? errorMessage}) {
    return SendPageState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      pageCommand: pageCommand,
    );
  }

  factory SendPageState.initial() {
    return const SendPageState(pageState: PageState.initial);
  }
}
