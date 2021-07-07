import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class RatesEvent extends Equatable {
  const RatesEvent();
  @override
  List<Object> get props => [];
}

class OnFetchRates extends RatesEvent {
  const OnFetchRates();
  @override
  String toString() => 'OnFetchRates';
}
