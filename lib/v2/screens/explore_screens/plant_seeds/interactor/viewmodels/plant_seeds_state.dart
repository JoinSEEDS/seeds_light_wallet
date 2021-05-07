import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class PlantSeedsState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;
  final String fiatAmount;
  final String? availableBalance;
  final String? availableBalanceFiat;
  final bool isPlantSeedsButtonEnabled;
  final String? errorMessage;

  const PlantSeedsState({
    required this.pageState,
    required this.ratesState,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    required this.isPlantSeedsButtonEnabled,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        isPlantSeedsButtonEnabled,
        errorMessage,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    String? fiatAmount,
    String? availableBalance,
    String? availableBalanceFiat,
    bool? isPlantSeedsButtonEnabled,
    String? errorMessage,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isPlantSeedsButtonEnabled: isPlantSeedsButtonEnabled ?? this.isPlantSeedsButtonEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PlantSeedsState.initial(RatesState ratesState) {
    return PlantSeedsState(
      pageState: PageState.initial,
      ratesState: ratesState,
      fiatAmount: 0.toString(),
      isPlantSeedsButtonEnabled: false,
    );
  }
}
