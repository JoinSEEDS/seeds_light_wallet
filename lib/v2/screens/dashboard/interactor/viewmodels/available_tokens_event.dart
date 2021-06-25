import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class AvailableTokensEvent extends Equatable {
  const AvailableTokensEvent();
  @override
  List<Object> get props => [];
}

class OnLoadAvailableTokens extends AvailableTokensEvent {

  const OnLoadAvailableTokens();

  @override
  String toString() => 'OnLoadAvailableTokens';
}

