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

class OnDeliveryTokenChange extends TransferExpertEvent {
  final String tokenId;

  const OnDeliveryTokenChange({required this.tokenId});

  @override
  String toString() => 'Delivery token changed to $tokenId';
}

class OnSwapInputAmountChange extends TransferExpertEvent {
  final double newAmount;
  final String selected;

  const OnSwapInputAmountChange({required this.newAmount, required this.selected});

  @override
  String toString() => 'Swap input value for "$selected" changed to $newAmount';
}
