import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

class ShowPlantSeedsSuccess extends PageCommand {}

/// --- STATE
class PlantSeedsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final RatesState ratesState;
  final bool isAutoFocus;
  final String fiatAmount;
  final BalanceModel? availableBalance;
  final String? availableBalanceFiat;
  final String? plantedBalance;
  final String? plantedBalanceFiat;
  final bool isPlantSeedsButtonEnabled;
  final double quantity;
  final bool showAlert;

  const PlantSeedsState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.ratesState,
    required this.isAutoFocus,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    this.plantedBalance,
    this.plantedBalanceFiat,
    required this.isPlantSeedsButtonEnabled,
    required this.quantity,
    required this.showAlert,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        ratesState,
        isAutoFocus,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        plantedBalance,
        plantedBalanceFiat,
        isPlantSeedsButtonEnabled,
        quantity,
        showAlert,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    RatesState? ratesState,
    bool? isAutoFocus,
    String? fiatAmount,
    BalanceModel? availableBalance,
    String? availableBalanceFiat,
    String? plantedBalance,
    String? plantedBalanceFiat,
    bool? isPlantSeedsButtonEnabled,
    double? quantity,
    bool? showAlert,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      ratesState: ratesState ?? this.ratesState,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      plantedBalance: plantedBalance ?? this.plantedBalance,
      plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
      isPlantSeedsButtonEnabled: isPlantSeedsButtonEnabled ?? this.isPlantSeedsButtonEnabled,
      quantity: quantity ?? this.quantity,
      showAlert: showAlert ?? this.showAlert,
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
      showAlert: false,
    );
  }
}
