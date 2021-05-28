import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class ShowPlantSeedsSuccessDialog extends PageCommand {}

class ShowTransactionFailSnackBar extends PageCommand {}

/// --- STATE
class PlantSeedsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
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
  final String? errorMessage;

  const PlantSeedsState({
    required this.pageState,
    this.pageCommand,
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
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
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
        errorMessage,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
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
    String? errorMessage,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
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
      showAlert: false,
    );
  }
}
