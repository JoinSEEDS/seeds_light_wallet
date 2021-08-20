import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';

/// --- STATE
class ReceiveEnterDataState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final RatesState ratesState;
  final double fiatAmount;
  final String? description;
  final BalanceModel? availableBalance;
  final double? availableBalanceSeeds;
  final double? availableBalanceFiat;
  final bool isNextButtonEnabled;
  final double quantity;
  final String? invoiceLink;
  final bool isAutoFocus;

  const ReceiveEnterDataState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.ratesState,
    required this.fiatAmount,
    this.availableBalance,
    this.availableBalanceFiat,
    this.availableBalanceSeeds,
    required this.isNextButtonEnabled,
    this.description,
    required this.quantity,
    this.invoiceLink,
    required this.isAutoFocus,
  });

  @override
  List<Object?> get props => [
        pageState,
        pageCommand,
        errorMessage,
        ratesState,
        fiatAmount,
        availableBalance,
        availableBalanceFiat,
        availableBalanceSeeds,
        isNextButtonEnabled,
        description,
        quantity,
        invoiceLink,
        isAutoFocus
      ];

  ReceiveEnterDataState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    RatesState? ratesState,
    double? fiatAmount,
    BalanceModel? availableBalance,
    double? availableBalanceFiat,
    bool? isNextButtonEnabled,
    double? availableBalanceSeeds,
    String? description,
    double? quantity,
    String? invoiceLink,
    String? seedsAmount,
    bool? isAutoFocus,
  }) {
    return ReceiveEnterDataState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      ratesState: ratesState ?? this.ratesState,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      availableBalance: availableBalance ?? this.availableBalance,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
      availableBalanceSeeds: availableBalanceSeeds ?? this.availableBalanceSeeds,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      invoiceLink: invoiceLink ?? this.invoiceLink,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
    );
  }

  factory ReceiveEnterDataState.initial(RatesState ratesState) {
    return ReceiveEnterDataState(
      availableBalanceSeeds: 0,
      availableBalanceFiat: 0,
      pageState: PageState.initial,
      ratesState: ratesState,
      fiatAmount: 0,
      isNextButtonEnabled: false,
      quantity: 0,
      isAutoFocus: true,
    );
  }
}
