import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class ExploreEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadExplore extends ExploreEvent {
  final String userName;

  @override
  String toString() => 'LoadExplore: { userName: $userName }';

  LoadExplore({@required this.userName});
}
