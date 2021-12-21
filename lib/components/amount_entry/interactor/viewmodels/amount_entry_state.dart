part of 'amount_entry_bloc.dart';

class AmountEntryState extends Equatable {
  final PageCommand? pageCommand;
  final CurrencyInput currentCurrencyInput;
  final RatesState ratesState;
  final TokenDataModel tokenAmount;
  final FiatDataModel? fiatAmount;
  final String textInput;

  bool get switchCurrencyEnabled => fiatAmount != null;

  const AmountEntryState({
    this.pageCommand,
    required this.currentCurrencyInput,
    required this.ratesState,
    required this.tokenAmount,
    required this.fiatAmount,
    required this.textInput,
  });

  @override
  List<Object?> get props => [
        pageCommand,
        currentCurrencyInput,
        ratesState,
        tokenAmount,
        fiatAmount,
        textInput,
      ];

  AmountEntryState copyWith({
    PageCommand? pageCommand,
    CurrencyInput? currentCurrencyInput,
    RatesState? ratesState,
    TokenDataModel? tokenAmount,
    FiatDataModel? fiatAmount,
    String? textInput,
  }) {
    return AmountEntryState(
      pageCommand: pageCommand,
      currentCurrencyInput: currentCurrencyInput ?? this.currentCurrencyInput,
      ratesState: ratesState ?? this.ratesState,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      fiatAmount: fiatAmount ?? this.fiatAmount,
      textInput: textInput ?? this.textInput,
    );
  }

  factory AmountEntryState.initial(RatesState ratesState, TokenDataModel tokenDataModel) {
    final fiatData = ratesState.tokenToFiat(tokenDataModel, settingsStorage.selectedFiatCurrency);
    return AmountEntryState(
      currentCurrencyInput: CurrencyInput.token,
      ratesState: ratesState,
      tokenAmount: tokenDataModel,
      fiatAmount: fiatData,
      textInput: 0.toString(),
    );
  }
}

enum CurrencyInput { fiat, token }
