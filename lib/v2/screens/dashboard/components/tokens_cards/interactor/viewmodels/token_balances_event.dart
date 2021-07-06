import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class TokenBalancesEvent extends Equatable {
  const TokenBalancesEvent();
  @override
  List<Object> get props => [];
}

class OnLoadTokenBalances extends TokenBalancesEvent {
  const OnLoadTokenBalances();

  @override
  String toString() => 'OnLoadTokenBalances';
}

class OnSelectedTokenChanged extends TokenBalancesEvent {
  final int index;

  const OnSelectedTokenChanged(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() => 'OnSelectedTokenChanged $index';
}
