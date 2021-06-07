import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class ReceiveEnterDataState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final RatesState ratesState;
  final String fiatAmount;
  final String? description;
  final BalanceModel? availableBalance;
  final String availableBalanceSeeds;
  final String availableBalanceFiat;
  final bool isNextButtonEnabled;
  final String? errorMessage;
  final double quantity;
  final String? invoiceLink;

  const ReceiveEnterDataState(
      {required this.pageState,
      this.pageCommand,
      required this.ratesState,
      required this.fiatAmount,
      this.availableBalance,
      required this.availableBalanceFiat,
      required this.availableBalanceSeeds,
      required this.isNextButtonEnabled,
      this.errorMessage,
      this.description,
      required this.quantity,
      this.invoiceLink});

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        ratesState,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        availableBalanceSeeds,
        isNextButtonEnabled,
        errorMessage,
        description,
        quantity,
        invoiceLink
      ];

  ReceiveEnterDataState copyWith(
      {PageState? pageState,
      PageCommand? pageCommand,
      RatesState? ratesState,
      String? fiatAmount,
      BalanceModel? availableBalance,
      String? availableBalanceFiat,
      bool? isNextButtonEnabled,
      String? errorMessage,
      String? availableBalanceSeeds,
      String? description,
      double? quantity,
      String? invoiceLink}) {
    return ReceiveEnterDataState(
        pageState: pageState ?? this.pageState,
        pageCommand: pageCommand,
        ratesState: ratesState ?? this.ratesState,
        fiatAmount: fiatAmount ?? this.fiatAmount,
        availableBalance: availableBalance ?? this.availableBalance,
        availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
        isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
        errorMessage: errorMessage ?? this.errorMessage,
        availableBalanceSeeds: availableBalanceSeeds ?? this.availableBalanceSeeds,
        description: description ?? this.description,
        quantity: quantity ?? this.quantity,
        invoiceLink: invoiceLink ?? this.invoiceLink);
  }

  factory ReceiveEnterDataState.initial(RatesState ratesState) {
    return ReceiveEnterDataState(
        availableBalanceSeeds: '',
        availableBalanceFiat: '',
        pageState: PageState.initial,
        ratesState: ratesState,
        fiatAmount: 0.toString(),
        isNextButtonEnabled: false,
        quantity: 0);
  }
}
