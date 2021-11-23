part of 'rates_bloc.dart';

class RatesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final RateModel? rate;
  final FiatRateModel? fiatRate;

  const RatesState({
    required this.pageState,
    this.errorMessage,
    this.rate,
    this.fiatRate,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        rate,
        fiatRate,
      ];

  RatesState copyWith({
    PageState? pageState,
    String? errorMessage,
    RateModel? rate,
    FiatRateModel? fiatRate,
  }) {
    return RatesState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      rate: rate ?? this.rate,
      fiatRate: fiatRate ?? this.fiatRate,
    );
  }

  factory RatesState.initial() {
    return const RatesState(pageState: PageState.initial);
  }
}
