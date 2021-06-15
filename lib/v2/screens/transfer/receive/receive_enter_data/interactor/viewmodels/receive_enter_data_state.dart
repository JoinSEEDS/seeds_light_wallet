import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATE
class ReceiveEnterDataState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final RatesState ratesState;
  final String fiatAmount;
  final String seedsAmount;
  final String? description;
  final BalanceModel? availableBalance;
  final String availableBalanceSeeds;
  final String availableBalanceFiat;
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
    required this.availableBalanceFiat,
    required this.availableBalanceSeeds,
    required this.isNextButtonEnabled,
    this.description,
    required this.quantity,
    this.invoiceLink,
    required this.isAutoFocus,
    required this.seedsAmount,
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
        seedsAmount,
        isAutoFocus
      ];

  ReceiveEnterDataState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    RatesState? ratesState,
    String? fiatAmount,
    BalanceModel? availableBalance,
    String? availableBalanceFiat,
    bool? isNextButtonEnabled,
    String? availableBalanceSeeds,
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
      seedsAmount: seedsAmount ?? this.seedsAmount,
    );
  }

  factory ReceiveEnterDataState.initial(RatesState ratesState) {
    return ReceiveEnterDataState(
      availableBalanceSeeds: '',
      availableBalanceFiat: '',
      pageState: PageState.initial,
      ratesState: ratesState,
      fiatAmount: 0.toString(),
      isNextButtonEnabled: false,
      quantity: 0,
      seedsAmount: '',
      isAutoFocus: true,
    );
  }
}
