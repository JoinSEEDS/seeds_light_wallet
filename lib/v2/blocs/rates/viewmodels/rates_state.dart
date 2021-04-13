import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/datasource/remote/model/rate_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

/// --- STATES
class RatesState extends Equatable {
  final PageState pageState;
  final RateModel? rate;
  final FiatRateModel? fiatRate;
  final String? errorMessage;

  const RatesState({
    required this.pageState,
    this.rate,
    this.fiatRate,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        pageState,
        rate,
        fiatRate,
        errorMessage,
      ];

  RatesState copyWith({
    PageState? pageState,
    RateModel? rate,
    FiatRateModel? fiatRate,
    String? errorMessage,
  }) {
    return RatesState(
      pageState: pageState ?? this.pageState,
      rate: rate ?? this.rate,
      fiatRate: fiatRate ?? this.fiatRate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory RatesState.initial() {
    return const RatesState(pageState: PageState.initial);
  }
}
