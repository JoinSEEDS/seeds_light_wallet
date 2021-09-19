import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class RecoveryPhraseEvent extends Equatable {
  const RecoveryPhraseEvent();

  @override
  List<Object> get props => [];
}
