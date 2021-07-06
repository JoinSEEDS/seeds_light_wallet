import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object> get props => [];
}

class OnLoadWalletData extends WalletEvent {
  const OnLoadWalletData();
  @override
  String toString() => 'OnLoadWalletData';
}
