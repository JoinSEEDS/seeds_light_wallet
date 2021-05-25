import 'package:equatable/equatable.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';

enum CurrencyInput { FIAT, SEEDS }

class AmountEntryState extends Equatable {
  final int decimalPrecision;
  final CurrencyInput currentCurrencyInput;
  final RatesState ratesState;
  final PageCommand? pageCommand;
  final String seedsAmount;
  final String seedsToFiat;
  final String fiatToSeeds;
  final String textInput;

  const AmountEntryState(
      {required this.decimalPrecision,
      required this.currentCurrencyInput,
      required this.ratesState,
      required this.seedsAmount,
      this.pageCommand,
      required this.fiatToSeeds,
      required this.seedsToFiat,
      required this.textInput});

  @override
  List<Object?> get props => [
        decimalPrecision,
        currentCurrencyInput,
        ratesState,
        seedsAmount,
        pageCommand,
        seedsToFiat,
        fiatToSeeds,
        textInput
      ];

  AmountEntryState copyWith({
    int? decimalPrecision,
    CurrencyInput? currentCurrencyInput,
    RatesState? ratesState,
    String? seedsAmount,
    PageCommand? pageCommand,
    String? fiatToSeeds,
    String? seedsToFiat,
    String? textInput,
  }) {
    return AmountEntryState(
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      currentCurrencyInput: currentCurrencyInput ?? this.currentCurrencyInput,
      ratesState: ratesState ?? this.ratesState,
      seedsAmount: seedsAmount ?? this.seedsAmount,
      pageCommand: pageCommand,
      fiatToSeeds: fiatToSeeds ?? this.fiatToSeeds,
      seedsToFiat: seedsToFiat ?? this.seedsToFiat,
      textInput: textInput ?? this.textInput,
    );
  }

  factory AmountEntryState.initial(RatesState ratesState) {
    return AmountEntryState(
        decimalPrecision: 4,
        currentCurrencyInput: CurrencyInput.SEEDS,
        ratesState: ratesState,
        seedsAmount: "0",
        fiatToSeeds: "0",
        seedsToFiat: "0",
        textInput: "0");
  }
}
