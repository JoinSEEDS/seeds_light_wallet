part of 'set_currency_bloc.dart';

class SetCurrencyState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final String? currentQuery;
  final List<Currency>? availableCurrencies;
  final List<Currency>? queryCurrenciesResults;

  const SetCurrencyState({
    required this.pageState,
    this.errorMessage,
    this.currentQuery,
    this.availableCurrencies,
    this.queryCurrenciesResults,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        currentQuery,
        availableCurrencies,
        queryCurrenciesResults,
      ];

  SetCurrencyState copyWith({
    PageState? pageState,
    String? errorMessage,
    String? currentQuery,
    List<Currency>? availableCurrencies,
    List<Currency>? queryCurrenciesResults,
  }) {
    return SetCurrencyState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      currentQuery: currentQuery ?? this.currentQuery,
      availableCurrencies: availableCurrencies ?? this.availableCurrencies,
      queryCurrenciesResults: queryCurrenciesResults ?? this.queryCurrenciesResults,
    );
  }

  factory SetCurrencyState.initial() {
    return const SetCurrencyState(pageState: PageState.initial);
  }
}
