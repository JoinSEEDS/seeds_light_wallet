part of 'rates_bloc.dart';

class RatesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final Map<String, RateModel>? rates;
  final FiatRateModel? fiatRate;

  const RatesState({
    required this.pageState,
    this.errorMessage,
    this.rates,
    this.fiatRate,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        rates,
        fiatRate,
      ];

  RatesState copyWith({
    PageState? pageState,
    String? errorMessage,
    Map<String, RateModel>? rates,
    FiatRateModel? fiatRate,
  }) {
    return RatesState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      rates: rates ?? this.rates,
      fiatRate: fiatRate ?? this.fiatRate,
    );
  }

  factory RatesState.initial() {
    return const RatesState(pageState: PageState.initial);
  }
}
