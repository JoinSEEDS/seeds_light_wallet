import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/token_balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class TokenBalancesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<TokenBalanceModel> availableTokens;

  const TokenBalancesState({
    required this.pageState,
    this.errorMessage,
    required this.availableTokens,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, availableTokens];

  TokenBalancesState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<TokenBalanceModel>? availableTokens,
  }) {
    return TokenBalancesState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      availableTokens: availableTokens ?? this.availableTokens,
    );
  }

  factory TokenBalancesState.initial() {
    return const TokenBalancesState(pageState: PageState.initial, availableTokens: [TokenBalanceModel(SeedsToken, null)]);
  }
}
