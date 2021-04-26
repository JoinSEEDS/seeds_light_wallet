import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'display_name_arguments.dart';

/// --- EVENTS
@immutable
abstract class DisplayNameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitDisplayNameConfirmationWithArguments extends DisplayNameEvent {
  final DisplayNameArguments arguments;

  InitDisplayNameConfirmationWithArguments({required this.arguments});

  @override
  String toString() => 'LoadDisplayNameConfirmation: { DisplayNameArguments: $arguments }';
}


