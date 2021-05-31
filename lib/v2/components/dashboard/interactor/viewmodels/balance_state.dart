import 'package:equatable/equatable.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/models/token_model.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class BalanceState extends Equatable {
  final PageState pageState;
  final TokenModel token;
  final String? error;
  final double amount;
  

  const BalanceState({required this.pageState, required this.token, this.error, required this.amount});

  @override
  List<Object?> get props => [token, error, amount, pageState];

  BalanceState copyWith({PageState? pageState, TokenModel? token, String? error, double? amount}) {
    return BalanceState(
      pageState: pageState ?? this.pageState,
      token: token ?? this.token,
      error: error ?? this.error,
      amount: amount ?? this.amount,
    );
  }

  String displayString() {
    switch (pageState) {
      case PageState.initial: return "...";
      case PageState.loading: return "...";
      case PageState.failure: return "...";
      case PageState.success: return amount.seedsFormatted + " " + token.symbol;        
      default:
      return "...";
    }
  }

  factory BalanceState.initial(TokenModel token) {
    return BalanceState(pageState: PageState.initial, token: token, amount: 0);
  }
}
