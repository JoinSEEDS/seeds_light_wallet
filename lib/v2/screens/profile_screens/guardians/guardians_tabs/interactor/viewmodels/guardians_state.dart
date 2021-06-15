import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final PageCommand? pageCommand;
  final int indexDialog;

  const GuardiansState({required this.pageState, this.errorMessage, this.pageCommand, required this.indexDialog});

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        pageCommand,
        indexDialog,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
    PageCommand? pageCommand,
    int? indexDialog,
  }) {
    return GuardiansState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage,
        pageCommand: pageCommand,
        indexDialog: indexDialog ?? this.indexDialog);
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial, indexDialog: 1);
  }
}
