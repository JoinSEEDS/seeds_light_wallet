import 'package:equatable/equatable.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/page_command.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

/// --- STATE
class ReceiveEnterDataState extends Equatable {
  final PageState pageState;
  final PageCommand? pageCommand;
  final String? errorMessage;
  final FiatDataModel? fiatAmount;
  final TokenDataModel tokenAmount;
  final TokenDataModel? availableBalanceToken;
  final FiatDataModel? availableBalanceFiat;
  final RatesState ratesState;
  final String? description;
  final bool isNextButtonEnabled;
  final String? invoiceLink;
  final bool isAutoFocus;

  const ReceiveEnterDataState({
    required this.pageState,
    this.pageCommand,
    this.errorMessage,
    required this.ratesState,
    required this.fiatAmount,
    this.availableBalanceFiat,
    this.availableBalanceToken,
    required this.isNextButtonEnabled,
    this.description,
    required this.tokenAmount,
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
        availableBalanceFiat,
        availableBalanceToken,
        isNextButtonEnabled,
        description,
        tokenAmount,
        invoiceLink,
        isAutoFocus
      ];

  ReceiveEnterDataState copyWith({
    PageState? pageState,
    PageCommand? pageCommand,
    String? errorMessage,
    RatesState? ratesState,
    FiatDataModel? fiatAmount,
    TokenDataModel? tokenAmount,
    TokenDataModel? availableBalanceToken,
    FiatDataModel? availableBalanceFiat,
    bool? isNextButtonEnabled,
    String? description,
    String? invoiceLink,
    bool? isAutoFocus,
  }) {
    return ReceiveEnterDataState(
      pageState: pageState ?? this.pageState,
      pageCommand: pageCommand,
      errorMessage: errorMessage,
      ratesState: ratesState ?? this.ratesState,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      availableBalanceFiat: availableBalanceFiat ?? this.availableBalanceFiat,
      availableBalanceToken: availableBalanceToken ?? this.availableBalanceToken,
      isNextButtonEnabled: isNextButtonEnabled ?? this.isNextButtonEnabled,
      description: description ?? this.description,
      invoiceLink: invoiceLink ?? this.invoiceLink,
      isAutoFocus: isAutoFocus ?? this.isAutoFocus,
    );
  }

  factory ReceiveEnterDataState.initial(RatesState ratesState) {
    final tokenAmount = TokenDataModel.fromSelected(0);
    return ReceiveEnterDataState(
      availableBalanceToken: tokenAmount,
      availableBalanceFiat: ratesState.tokenToFiat(tokenAmount, settingsStorage.selectedFiatCurrency),
      pageState: PageState.initial,
      ratesState: ratesState,
      fiatAmount: ratesState.tokenToFiat(tokenAmount, settingsStorage.selectedFiatCurrency),
      isNextButtonEnabled: false,
      tokenAmount: tokenAmount,
      isAutoFocus: true,
    );
  }
}
