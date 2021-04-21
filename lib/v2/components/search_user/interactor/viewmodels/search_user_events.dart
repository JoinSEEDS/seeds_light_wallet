import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// --- EVENTS
@immutable
abstract class SearchUserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnSearchChange extends SearchUserEvent {
  final String searchQuery;

  OnSearchChange({required this.searchQuery});

  @override
  String toString() => 'OnSearchChange: { searchQuery: $searchQuery }';
}
