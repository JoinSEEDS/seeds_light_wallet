import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/mappers/handle_info_row_text.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

enum CurrencyInput { fiat, token }

extension DecimalPrecision on CurrencyInput {
  int toDecimalPrecision() {
    switch (this) {
      case CurrencyInput.fiat:
        return 2;
      case CurrencyInput.token:
        return 4;
    }
  }
}

class AmountEntryState extends Equatable {
  final CurrencyInput currentCurrencyInput;
  final RatesState ratesState;
  final PageCommand? pageCommand;
  final TokenModel token;
  final String infoRowText;
  final String enteringCurrencyName;
  final String seedsAmount;
  final String seedsToFiat;
  final String fiatToSeeds;
  final String textInput;

  const AmountEntryState({
    required this.currentCurrencyInput,
    required this.ratesState,
    this.pageCommand,
    required this.token,
    required this.infoRowText,
    required this.enteringCurrencyName,
    required this.seedsAmount,
    required this.fiatToSeeds,
    required this.seedsToFiat,
    required this.textInput,
  });

  @override
  List<Object?> get props => [
        currentCurrencyInput,
        ratesState,
        seedsAmount,
        pageCommand,
        seedsToFiat,
        fiatToSeeds,
        textInput,
        infoRowText,
        enteringCurrencyName,
        token,
      ];

  AmountEntryState copyWith({
    CurrencyInput? currentCurrencyInput,
    RatesState? ratesState,
    TokenModel? token,
    String? infoRowText,
    String? enteringCurrencyName,
    String? seedsAmount,
    PageCommand? pageCommand,
    String? fiatToSeeds,
    String? seedsToFiat,
    String? textInput,
  }) {
    return AmountEntryState(
      currentCurrencyInput: currentCurrencyInput ?? this.currentCurrencyInput,
      ratesState: ratesState ?? this.ratesState,
      seedsAmount: seedsAmount ?? this.seedsAmount,
      enteringCurrencyName: enteringCurrencyName ?? this.enteringCurrencyName,
      infoRowText: infoRowText ?? this.infoRowText,
      pageCommand: pageCommand,
      fiatToSeeds: fiatToSeeds ?? this.fiatToSeeds,
      seedsToFiat: seedsToFiat ?? this.seedsToFiat,
      textInput: textInput ?? this.textInput,
      token: token ?? this.token,
    );
  }

  factory AmountEntryState.initial(RatesState ratesState, TokenModel token) {
    return AmountEntryState(
        currentCurrencyInput: CurrencyInput.token,
        ratesState: ratesState,
        token: token,
        infoRowText: handleInfoRowText(currentCurrencyInput: CurrencyInput.token, fiatToSeeds: "0", seedsToFiat: "0"),
        enteringCurrencyName: token.symbol,
        seedsAmount: "0",
        fiatToSeeds: "0",
        seedsToFiat: "0",
        textInput: "0");
  }
}
