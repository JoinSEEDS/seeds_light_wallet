import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class BalanceState extends Equatable {
  final PageState pageState;
  final TokenModel token;
  final String? error;
  final double? amount;
  final String cardDisplayText;
  

  const BalanceState({required this.pageState, required this.token, this.error, this.amount, required this.cardDisplayText});

  @override
  List<Object?> get props => [token, error, amount, pageState, cardDisplayText];

  BalanceState copyWith({PageState? pageState, TokenModel? token, String? error, double? amount, String? cardDisplayText}) {    
    return BalanceState(
      pageState: pageState ?? this.pageState,
      token: token ?? this.token,
      error: error ?? this.error,
      amount: amount ?? this.amount,
      cardDisplayText: cardDisplayText ?? this.cardDisplayText
    );
  }

  factory BalanceState.initial(TokenModel token) {
    return BalanceState(pageState: PageState.initial, token: token, cardDisplayText: "...");
  }
}
