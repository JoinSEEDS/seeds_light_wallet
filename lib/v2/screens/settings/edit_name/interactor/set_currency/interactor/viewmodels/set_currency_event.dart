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
  const LoadCurrencies();
  @override
  String toString() => 'LoadCurrencies';
}
