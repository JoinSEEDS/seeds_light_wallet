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
  final String? plantedBalance;
  final String? plantedBalanceFiat;
  final bool isPlantSeedsButtonEnabled;
  final double quantity;
  final bool showPlantedSuccess;
  final String? errorMessage;

  const PlantSeedsState({
    required this.pageState,
    required this.ratesState,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    this.plantedBalance,
    this.plantedBalanceFiat,
    required this.isPlantSeedsButtonEnabled,
    required this.quantity,
    required this.showPlantedSuccess,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        plantedBalance,
        plantedBalanceFiat,
        isPlantSeedsButtonEnabled,
        quantity,
        showPlantedSuccess,
        errorMessage,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    String? fiatAmount,
    String? availableBalance,
    String? availableBalanceFiat,
    String? plantedBalance,
    String? plantedBalanceFiat,
    bool? isPlantSeedsButtonEnabled,
    double? quantity,
    bool? showPlantedSuccess,
    String? errorMessage,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      plantedBalance: plantedBalance ?? this.plantedBalance,
      plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
      isPlantSeedsButtonEnabled: isPlantSeedsButtonEnabled ?? this.isPlantSeedsButtonEnabled,
      quantity: quantity ?? this.quantity,
      showPlantedSuccess: showPlantedSuccess ?? this.showPlantedSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PlantSeedsState.initial(RatesState ratesState) {
    return PlantSeedsState(
      pageState: PageState.initial,
      ratesState: ratesState,
      fiatAmount: 0.toString(),
      isPlantSeedsButtonEnabled: false,
      quantity: 0,
      showPlantedSuccess: false,
    );
  }
}
