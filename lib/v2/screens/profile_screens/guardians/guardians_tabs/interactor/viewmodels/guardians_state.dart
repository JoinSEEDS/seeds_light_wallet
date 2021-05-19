import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final PageCommand? pageCommand;

  const GuardiansState({
    required this.pageState,
    this.errorMessage,
    this.pageCommand,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        pageCommand,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
    PageCommand? pageCommand,
  }) {
    return GuardiansState(pageState: pageState ?? this.pageState, errorMessage: errorMessage, pageCommand: pageCommand);
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial);
  }
}
