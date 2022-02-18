part of 'receive_details_bloc.dart';

class ReceiveDetailsState extends Equatable {
  final PageState pageState;
  final ReceiveDetails details;
  final TransactionModel? receivePaidTransaction;

  const ReceiveDetailsState({
    required this.pageState,
    required this.details,
    this.receivePaidTransaction,
  });

  @override
  List<Object?> get props => [
        pageState,
        details,
        receivePaidTransaction,
      ];

  ReceiveDetailsState copyWith({PageState? pageState, TransactionModel? receivePaidTransaction}) {
    return ReceiveDetailsState(
      pageState: pageState ?? this.pageState,
      details: details,
      receivePaidTransaction: receivePaidTransaction,
    );
  }

  factory ReceiveDetailsState.initial(ReceiveDetails details) {
    return ReceiveDetailsState(pageState: PageState.initial, details: details);
  }
}
