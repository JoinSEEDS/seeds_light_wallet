import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/local/models/currency.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATES
class SetCurrencyState extends Equatable {
  final PageState pageState;
  final String? currentQuery;
  final List<Currency>? availableCurrencies;
  final List<Currency>? queryCurrenciesResults;
  final String? errorMessage;

  const SetCurrencyState({
    required this.pageState,
    this.currentQuery,
    this.availableCurrencies,
    this.queryCurrenciesResults,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        currentQuery,
        availableCurrencies,
        queryCurrenciesResults,
        errorMessage,
      ];

  SetCurrencyState copyWith({
    PageState? pageState,
    String? currentQuery,
    List<Currency>? availableCurrencies,
    List<Currency>? queryCurrenciesResults,
    String? errorMessage,
  }) {
    return SetCurrencyState(
      pageState: pageState ?? this.pageState,
      currentQuery: currentQuery ?? this.currentQuery,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      queryCurrenciesResults: queryCurrenciesResults ?? this.queryCurrenciesResults,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory SetCurrencyState.initial() {
    return const SetCurrencyState(pageState: PageState.initial);
  }
}
