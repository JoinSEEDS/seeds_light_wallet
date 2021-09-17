import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/domain-shared/page_state.dart';

class UnplantSeedsState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;

  const UnplantSeedsState({
    required this.pageState,
    required this.ratesState,
  });

  @override
  List<Object?> get props => [pageState, ratesState];

  UnplantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
  }) {
    return UnplantSeedsState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
    );
  }

  factory UnplantSeedsState.initial(RatesState ratesState) {
    return UnplantSeedsState(
      pageState: PageState.success,
      ratesState: ratesState,
    );
  }
}
