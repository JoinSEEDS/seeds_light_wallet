import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class PlantSeedsState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;
  final bool isAutoFocus;
  final String fiatAmount;
  final BalanceModel? availableBalance;
  final String? availableBalanceFiat;
  final String? plantedBalance;
  final String? plantedBalanceFiat;
  final bool isPlantSeedsButtonEnabled;
  final double quantity;
  final bool showToast;
  final bool showPlantedSuccess;
  final String? errorMessage;

  const PlantSeedsState({
    required this.pageState,
    required this.ratesState,
    required this.isAutoFocus,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    this.plantedBalance,
    this.plantedBalanceFiat,
    required this.isPlantSeedsButtonEnabled,
    required this.quantity,
    required this.showToast,
    required this.showPlantedSuccess,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        isAutoFocus,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        plantedBalance,
        plantedBalanceFiat,
        isPlantSeedsButtonEnabled,
        quantity,
        showToast,
        showPlantedSuccess,
        errorMessage,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    bool? isAutoFocus,
    String? fiatAmount,
    BalanceModel? availableBalance,
    String? availableBalanceFiat,
    String? plantedBalance,
    String? plantedBalanceFiat,
    bool? isPlantSeedsButtonEnabled,
    double? quantity,
    bool? showToast,
    bool? showPlantedSuccess,
    String? errorMessage,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      plantedBalance: plantedBalance ?? this.plantedBalance,
      plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
      isPlantSeedsButtonEnabled: isPlantSeedsButtonEnabled ?? this.isPlantSeedsButtonEnabled,
      quantity: quantity ?? this.quantity,
      showToast: showToast ?? this.showToast,
      showPlantedSuccess: showPlantedSuccess ?? this.showPlantedSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory PlantSeedsState.initial(RatesState ratesState) {
    return PlantSeedsState(
      pageState: PageState.initial,
      ratesState: ratesState,
      isAutoFocus: true,
      fiatAmount: 0.toString(),
      isPlantSeedsButtonEnabled: false,
      quantity: 0,
      showToast: false,
      showPlantedSuccess: false,
    );
  }
}
