import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AmountEntryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TabCurrencySwitchButton extends AmountEntryEvent {
  final int intPrecision;


  TabCurrencySwitchButton({required this.intPrecision});

  @override
  String toString() => 'OnSearchChange: { searchQuery: $intPrecision }';
}


