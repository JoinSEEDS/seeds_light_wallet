import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/amount_entry/interactor/mappers/handle_info_row_text.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';

enum CurrencyInput { FIAT, SEEDS }

extension DecimalPrecision on CurrencyInput {
  int toDecimalPrecision() {
    switch (this) {
      case CurrencyInput.FIAT:
        return 2;
      case CurrencyInput.SEEDS:
        return 4;
    }
  }
}

class AmountEntryState extends Equatable {
  final CurrencyInput currentCurrencyInput;
  final RatesState ratesState;
  final PageCommand? pageCommand;
  final String infoRowText;
  final String enteringCurrencyName;
  final String seedsAmount;
  final String seedsToFiat;
  final String fiatToSeeds;
  final String textInput;

  const AmountEntryState({
    required this.currentCurrencyInput,
    required this.ratesState,
    required this.infoRowText,
    required this.enteringCurrencyName,
    required this.seedsAmount,
    this.pageCommand,
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
      ];

  AmountEntryState copyWith({
    CurrencyInput? currentCurrencyInput,
    RatesState? ratesState,
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
    );
  }

  factory AmountEntryState.initial(RatesState ratesState) {
    return AmountEntryState(
        currentCurrencyInput: CurrencyInput.SEEDS,
        ratesState: ratesState,
        infoRowText: handleInfoRowText(currentCurrencyInput: CurrencyInput.SEEDS, fiatToSeeds: "0", seedsToFiat: "0"),
        enteringCurrencyName: currencySeedsCode,
        seedsAmount: "0",
        fiatToSeeds: "0",
        seedsToFiat: "0",
        textInput: "0");
  }
}
