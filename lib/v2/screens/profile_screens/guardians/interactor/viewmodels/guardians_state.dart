import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class GuardiansState extends Equatable {
  final PageState pageState;

  const GuardiansState({
    required this.pageState,
  });

  @override
  List<Object?> get props => [
        pageState,
      ];

  GuardiansState copyWith({
    PageState? pageState,
  }) {
    return GuardiansState(
      pageState: pageState ?? this.pageState,
    );
  }

  factory GuardiansState.initial() {
    return const GuardiansState(pageState: PageState.initial);
  }
}
