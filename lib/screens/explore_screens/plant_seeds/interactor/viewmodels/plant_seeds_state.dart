part of 'plant_seeds_bloc.dart';

class PlantSeedsState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final PlantSeedsError? error;
  final RatesState ratesState;
  final bool isAutoFocus;
  final TokenDataModel tokenAmount;
  final FiatDataModel fiatAmount;
  final TokenDataModel? availableBalance;
  final FiatDataModel? availableBalanceFiat;
  final TokenDataModel? plantedBalance;
  final FiatDataModel? plantedBalanceFiat;
  final bool isPlantSeedsButtonEnabled;
  final bool showAlert;

  const PlantSeedsState({
    required this.pageState,
    this.pageCommand,
    this.error,
    required this.ratesState,
    required this.isAutoFocus,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    this.plantedBalance,
    this.plantedBalanceFiat,
    required this.isPlantSeedsButtonEnabled,
    required this.tokenAmount,
    required this.showAlert,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        error,
        ratesState,
        isAutoFocus,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        plantedBalance,
        plantedBalanceFiat,
        isPlantSeedsButtonEnabled,
        tokenAmount,
        showAlert,
      ];

  PlantSeedsState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    PlantSeedsError? error,
    RatesState? ratesState,
    bool? isAutoFocus,
    TokenDataModel? tokenAmount,
    FiatDataModel? fiatAmount,
    TokenDataModel? availableBalance,
    FiatDataModel? availableBalanceFiat,
    TokenDataModel? plantedBalance,
    FiatDataModel? plantedBalanceFiat,
    bool? isPlantSeedsButtonEnabled,
    bool? showAlert,
  }) {
    return PlantSeedsState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      error: error,
      ratesState: ratesState ?? this.ratesState,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      plantedBalance: plantedBalance ?? this.plantedBalance,
      plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
      isPlantSeedsButtonEnabled: isPlantSeedsButtonEnabled ?? this.isPlantSeedsButtonEnabled,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      showAlert: showAlert ?? this.showAlert,
    );
  }

  factory PlantSeedsState.initial(RatesState ratesState) {
    return PlantSeedsState(
      pageState: PageState.initial,
      ratesState: ratesState,
      isAutoFocus: true,
      tokenAmount: TokenDataModel(0, token: seedsToken),
      fiatAmount: FiatDataModel(0),
      isPlantSeedsButtonEnabled: false,
      showAlert: false,
    );
  }
}

class ShowPlantSeedsSuccess extends PageCommand {}
