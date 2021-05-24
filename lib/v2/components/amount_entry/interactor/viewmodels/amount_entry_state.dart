import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

enum CurrentCurrencyInput { fiat, seeds }

class AmountEntryState extends Equatable {
  final PageState pageState;
  final String? error;
  final int decimalPrecision;
  final CurrentCurrencyInput currentCurrencyInput;

  const AmountEntryState(
      {required this.pageState, this.error, required this.decimalPrecision, required this.currentCurrencyInput});

  @override
  List<Object?> get props => [pageState, error, decimalPrecision, currentCurrencyInput];

  AmountEntryState copyWith(
      {PageState? pageState, String? error, int? decimalPrecision, CurrentCurrencyInput? currentCurrencyInput}) {
    return AmountEntryState(
        pageState: pageState ?? this.pageState,
        error: error ?? this.error,
        decimalPrecision: decimalPrecision ?? this.decimalPrecision,
        currentCurrencyInput: currentCurrencyInput ?? this.currentCurrencyInput);
  }

  factory AmountEntryState.initial() {
    return const AmountEntryState(
        pageState: PageState.initial, decimalPrecision: 4, currentCurrencyInput: CurrentCurrencyInput.seeds);
  }
}
