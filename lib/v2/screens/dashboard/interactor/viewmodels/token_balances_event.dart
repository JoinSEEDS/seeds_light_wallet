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

