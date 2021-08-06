import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ExploreState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;

  const ExploreState({
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

  ExploreState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
  }) {
    return ExploreState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
    );
  }

  factory ExploreState.initial() {
    return const ExploreState(pageState: PageState.initial);
  }
}
