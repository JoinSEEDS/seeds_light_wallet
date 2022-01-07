part of 'search_user_bloc.dart';

abstract class SearchUserEvent extends Equatable {
  const SearchUserEvent();

  @override
  List<Object?> get props => [];
}

class OnSearchChange extends SearchUserEvent {
  final String searchQuery;

  const OnSearchChange({required this.searchQuery});

  @override
  String toString() => 'OnSearchChange: { searchQuery: $searchQuery }';
}

class ClearIconTapped extends SearchUserEvent {
  const ClearIconTapped();

  @override
  String toString() => 'ClearIconTapped';
}
