import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class GuardiansState extends Equatable {
  final PageState pageState;
  final String? errorMessage;

  const GuardiansState({required this.pageState, this.errorMessage});

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
      ];

  GuardiansState copyWith({
    PageState? pageState,
    String? errorMessage,
  }) {
    return GuardiansState(pageState: pageState ?? this.pageState, errorMessage: errorMessage);
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial);
  }
}
