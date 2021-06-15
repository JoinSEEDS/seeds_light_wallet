import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class BalanceState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final TokenModel token;
  final double? amount;
  final String cardDisplayText;

  const BalanceState({
    required this.pageState,
    this.errorMessage,
    required this.token,
    this.amount,
    required this.cardDisplayText,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, token, amount, cardDisplayText];

  BalanceState copyWith({
    PageState? pageState,
    String? errorMessage,
    TokenModel? token,
    double? amount,
    String? cardDisplayText,
  }) {
    return BalanceState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      token: token ?? this.token,
      amount: amount ?? this.amount,
      cardDisplayText: cardDisplayText ?? this.cardDisplayText,
    );
  }

  factory BalanceState.initial(TokenModel token) {
    return BalanceState(pageState: PageState.initial, token: token, cardDisplayText: "...");
  }
}
