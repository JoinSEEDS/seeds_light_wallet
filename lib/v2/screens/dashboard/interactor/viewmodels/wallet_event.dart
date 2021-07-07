import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class RefreshDataEvent extends WalletEvent {
  const RefreshDataEvent();

  @override
  String toString() => 'RefreshDataEvent';
}

class LoadUserValues extends WalletEvent {
  @override
  String toString() => 'LoadProfileValues';
}
