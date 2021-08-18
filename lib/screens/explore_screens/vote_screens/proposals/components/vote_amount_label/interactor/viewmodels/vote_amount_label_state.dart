import 'package:equatable/equatable.dart';
import 'package:seeds/domain-shared/page_state.dart';

/// --- STATE
class VoteAmountLabelState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final int amount;

  const VoteAmountLabelState({
    required this.pageState,
    this.errorMessage,
    required this.amount,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, amount];

  VoteAmountLabelState copyWith({PageState? pageState, String? errorMessage, int? amount}) {
    return VoteAmountLabelState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      amount: amount ?? this.amount,
    );
  }

  factory VoteAmountLabelState.initial() {
    return const VoteAmountLabelState(pageState: PageState.initial, amount: 0);
  }
}
