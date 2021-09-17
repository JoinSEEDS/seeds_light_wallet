import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/domain-shared/page_state.dart';

class UnplantSeedsState extends Equatable {
  final PageState pageState;
  final RatesState ratesState;
  final TokenDataModel unplantedInputAmount;
  final FiatDataModel unplantedInputAmountFiat;
  final bool onFocus;
  final TokenDataModel? plantedBalance;
  final FiatDataModel? plantedBalanceFiat;
  final bool isUnplantSeedsButtonEnabled;
  final bool showAlert;
  final TextEditingController controller;

  const UnplantSeedsState(
      {required this.pageState,
      required this.ratesState,
      required this.unplantedInputAmountFiat,
      required this.onFocus,
      this.plantedBalance,
      this.plantedBalanceFiat,
      required this.isUnplantSeedsButtonEnabled,
      required this.showAlert,
      required this.unplantedInputAmount,
      required this.controller});

  @override
  List<Object?> get props => [
        pageState,
        ratesState,
        onFocus,
        plantedBalance,
        plantedBalanceFiat,
        isUnplantSeedsButtonEnabled,
        showAlert,
        unplantedInputAmountFiat,
        unplantedInputAmount,
        controller,
      ];

  UnplantSeedsState copyWith({
    PageState? pageState,
    RatesState? ratesState,
    double? unplantAmount,
    bool? onFocus,
    TokenDataModel? plantedBalance,
    FiatDataModel? plantedBalanceFiat,
    bool? isUnplantSeedsButtonEnabled,
    bool? showAlert,
    FiatDataModel? unplantedInputAmountFiat,
    TokenDataModel? unplantedInputAmount,
    TextEditingController? controller,
  }) {
    return UnplantSeedsState(
        pageState: pageState ?? this.pageState,
        ratesState: ratesState ?? this.ratesState,
        onFocus: onFocus ?? this.onFocus,
        plantedBalance: plantedBalance ?? this.plantedBalance,
        plantedBalanceFiat: plantedBalanceFiat ?? this.plantedBalanceFiat,
        isUnplantSeedsButtonEnabled: isUnplantSeedsButtonEnabled ?? this.isUnplantSeedsButtonEnabled,
        showAlert: showAlert ?? this.showAlert,
        unplantedInputAmountFiat: unplantedInputAmountFiat ?? this.unplantedInputAmountFiat,
        unplantedInputAmount: unplantedInputAmount ?? this.unplantedInputAmount,
        controller: controller ?? this.controller);
  }

  factory UnplantSeedsState.initial(RatesState ratesState) {
    return UnplantSeedsState(
      pageState: PageState.success,
      ratesState: ratesState,
      onFocus: true,
      unplantedInputAmountFiat: FiatDataModel(0),
      showAlert: false,
      isUnplantSeedsButtonEnabled: false,
      unplantedInputAmount: TokenDataModel(0),
      controller: TextEditingController(),
    );
  }
}
