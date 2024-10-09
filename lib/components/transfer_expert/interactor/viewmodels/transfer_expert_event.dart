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
  final GlobalKey<AmountEntryWidgetState> otherKey;

  const OnSwapInputAmountChange({required this.newAmount, required this.selected, required this.otherKey});

  @override
  String toString() => 'Swap input value for "$selected" changed to $newAmount';
}

class OnOSwapLoad extends TransferExpertEvent {

  const OnOSwapLoad();

  @override
  String toString() => 'oSwapLoad';
}

class OnSwapNextButtonTapped extends TransferExpertEvent {
  final TransferExpertState state;

  const OnSwapNextButtonTapped(this.state);

  @override
  String toString() => 'Swap next button tapped';
}

class OnSwapSendButtonTapped extends TransferExpertEvent {
  
  const OnSwapSendButtonTapped();

  @override
  String toString() => 'Swap send button tapped';
}

class OnMemoChange extends TransferExpertEvent {
  final String memoChanged;

  const OnMemoChange({required this.memoChanged});

  @override
  String toString() => 'OnMemoChange: { OnMemoChange: $memoChanged }';
}
class ClearPageCommand extends TransferExpertEvent {

  const ClearPageCommand();
  @override
  String toString() => 'ClearPageCommand';
}