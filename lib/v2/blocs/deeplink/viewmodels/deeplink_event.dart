import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class DeeplinkEvent extends Equatable {
  const DeeplinkEvent();

  @override
  List<Object> get props => [];
}
