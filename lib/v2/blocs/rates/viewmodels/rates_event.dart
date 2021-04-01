import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class RatesEvent extends Equatable {
  const RatesEvent();
  @override
  List<Object> get props => [];
}

class FetchRates extends RatesEvent {
  const FetchRates();
  @override
  String toString() => 'FetchRates';
}
