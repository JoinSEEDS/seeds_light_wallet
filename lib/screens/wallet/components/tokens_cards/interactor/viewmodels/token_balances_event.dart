part of 'token_balances_bloc.dart';

abstract class TokenBalancesEvent extends Equatable {
  const TokenBalancesEvent();

  @override
  List<Object?> get props => [];
}

class OnLoadTokenBalances extends TokenBalancesEvent {
  const OnLoadTokenBalances();

  @override
  String toString() => 'OnLoadTokenBalances';
}

class OnFiatCurrencyChanged extends TokenBalancesEvent {
  const OnFiatCurrencyChanged();

  @override
  String toString() => 'OnFiatCurrencyChanged';
}

class OnSelectedTokenChanged extends TokenBalancesEvent {
  final int index;

  const OnSelectedTokenChanged(this.index);

  @override
  List<Object?> get props => [index];

  @override
  String toString() => 'OnSelectedTokenChanged $index';
}
