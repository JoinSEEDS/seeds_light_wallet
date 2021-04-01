import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SetCurrencyEvent extends Equatable {
  const SetCurrencyEvent();
  @override
  List<Object> get props => [];
}

class LoadCurrencies extends SetCurrencyEvent {
  final Map<String, double> rates;

  const LoadCurrencies({@required this.rates}) : assert(rates != null);

  @override
  List<Object> get props => [rates];

  @override
  String toString() => 'LoadCurrencies: { $rates }';
}

class OnQueryChanged extends SetCurrencyEvent {
  final String query;

  const OnQueryChanged({@required this.query}) : assert(query != null);

  @override
  List<Object> get props => [query];
  @override
  String toString() => 'OnQueryChanged { query: $query }';
}
