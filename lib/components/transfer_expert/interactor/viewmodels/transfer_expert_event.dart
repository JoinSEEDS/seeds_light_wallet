part of 'transfer_expert_bloc.dart';

abstract class TransferExpertEvent extends Equatable {
  const TransferExpertEvent();

  @override
  List<Object?> get props => [];
}

class OnSearchChange extends TransferExpertEvent {
  final String searchQuery;
  final String accountKey;

  const OnSearchChange({required this.searchQuery, required this.accountKey});

  @override
  String toString() => 'OnSearchChange: { searchQuery: $searchQuery }';
}

class ClearIconTapped extends TransferExpertEvent {
  const ClearIconTapped();

  @override
  String toString() => 'ClearIconTapped';
}
