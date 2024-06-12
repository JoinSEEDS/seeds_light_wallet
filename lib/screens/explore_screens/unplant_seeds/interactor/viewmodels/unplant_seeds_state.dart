part of 'unplant_seeds_bloc.dart';

class UnplantSeedsState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;
  final TokenDataModel unplantedInputAmount;
  final FiatDataModel unplantedInputAmountFiat;
  final bool onFocus;
  final TokenDataModel? plantedBalance;
  final FiatDataModel? plantedBalanceFiat;
  final bool isUnplantSeedsButtonEnabled;
  final bool showOverBalanceAlert;
  final bool showMinPlantedBalanceAlert;
  final PageCommand? pageCommand;
  final bool showUnclaimedBalance;
  final TokenDataModel? availableClaimBalance;
  final FiatDataModel? availableClaimBalanceFiat;
  final List<int>? availableRequestIds;
  final bool isClaimButtonEnabled;

  const UnplantSeedsState({
    required this.pageState,
    required this.ratesState,
    required this.unplantedInputAmountFiat,
    required this.onFocus,
    this.plantedBalance,
    this.plantedBalanceFiat,
    required this.isUnplantSeedsButtonEnabled,
    required this.showOverBalanceAlert,
    required this.showMinPlantedBalanceAlert,
    required this.unplantedInputAmount,
    this.pageCommand,
    required this.showUnclaimedBalance,
    this.availableClaimBalance,
    this.availableClaimBalanceFiat,
    this.availableRequestIds,
    required this.isClaimButtonEnabled,
  });

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        onFocus,
        plantedBalance,
        plantedBalanceFiat,
        isUnplantSeedsButtonEnabled,
        showOverBalanceAlert,
        unplantedInputAmountFiat,
        unplantedInputAmount,
        pageCommand,
        showMinPlantedBalanceAlert,
        showUnclaimedBalance,
        availableClaimBalance,
        availableClaimBalanceFiat,
        availableRequestIds,
        isClaimButtonEnabled,
      ];

  UnplantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    double? unplantAmount,
    bool? onFocus,
    TokenDataModel? plantedBalance,
    FiatDataModel? plantedBalanceFiat,
    bool? isUnplantSeedsButtonEnabled,
    bool? showOverBalanceAlert,
    bool? showMinPlantedBalanceAlert,
    FiatDataModel? unplantedInputAmountFiat,
    TokenDataModel? unplantedInputAmount,
    PageCommand? pageCommand,
    bool? showUnclaimedBalance,
    TokenDataModel? availableClaimBalance,
    FiatDataModel? availableClaimBalanceFiat,
    List<int>? availableRequestIds,
    bool? isClaimButtonEnabled,
  }) {
    return UnplantSeedsState(
      pageState: pageState ?? this.pageState,
      ratesState: ratesState ?? this.ratesState,
      onFocus: onFocus ?? this.onFocus,
      plantedBalance: plantedBalance ?? this.plantedBalance,
      plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
      isUnplantSeedsButtonEnabled: isUnplantSeedsButtonEnabled ?? this.isUnplantSeedsButtonEnabled,
      showOverBalanceAlert: showOverBalanceAlert ?? this.showOverBalanceAlert,
      showMinPlantedBalanceAlert: showMinPlantedBalanceAlert ?? this.showMinPlantedBalanceAlert,
      unplantedInputAmountFiat: unplantedInputAmountFiat ?? this.unplantedInputAmountFiat,
      unplantedInputAmount: unplantedInputAmount ?? this.unplantedInputAmount,
      pageCommand: pageCommand,
      showUnclaimedBalance: showUnclaimedBalance ?? this.showUnclaimedBalance,
      availableClaimBalance: availableClaimBalance ?? this.availableClaimBalance,
      availableClaimBalanceFiat: availableClaimBalanceFiat ?? this.availableClaimBalanceFiat,
      availableRequestIds: availableRequestIds ?? this.availableRequestIds,
      isClaimButtonEnabled: isClaimButtonEnabled ?? this.isClaimButtonEnabled,
    );
  }

  factory UnplantSeedsState.initial(RatesState ratesState, bool claimUnplantedSeedsEnabled) {
    return UnplantSeedsState(
      pageState: PageState.success,
      ratesState: ratesState,
      onFocus: true,
      unplantedInputAmountFiat: FiatDataModel(0),
      showOverBalanceAlert: false,
      showMinPlantedBalanceAlert: false,
      isUnplantSeedsButtonEnabled: false,
      unplantedInputAmount: TokenDataModel(0),
      showUnclaimedBalance: claimUnplantedSeedsEnabled,
      isClaimButtonEnabled: false,
    );
  }
}
