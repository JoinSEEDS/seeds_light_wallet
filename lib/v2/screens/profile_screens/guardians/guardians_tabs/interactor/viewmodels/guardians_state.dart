import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;

  const GuardiansState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
  }) {
    return GuardiansState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
    );
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial);
  }
}
