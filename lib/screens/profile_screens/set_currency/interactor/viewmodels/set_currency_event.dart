part of 'set_currency_bloc.dart';

abstract class SetCurrencyEvent extends Equatable {
  const SetCurrencyEvent();

  @override
  List<Object?> get props => [];
}

class LoadCurrencies extends SetCurrencyEvent {
  final Map<String?, num> rates;

  const LoadCurrencies(this.rates);

  @override
  List<Object?> get props => [rates];

  @override
  String toString() => 'LoadCurrencies: { $rates }';
}

class OnQueryChanged extends SetCurrencyEvent {
  final String query;

  const OnQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
  @override
  String toString() => 'OnQueryChanged { query: $query }';
}
