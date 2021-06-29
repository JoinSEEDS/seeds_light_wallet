import 'package:equatable/equatable.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/token_balance_view_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class TokenBalancesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<TokenBalanceViewModel> availableTokens;

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
    List<TokenBalanceViewModel>? availableTokens,
  }) {
    return TokenBalancesState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      availableTokens: availableTokens ?? this.availableTokens,
    );
  }

  factory TokenBalancesState.initial() {
    return const TokenBalancesState(pageState: PageState.initial, availableTokens: [TokenBalanceViewModel(SeedsToken, null)]);
  }
}
