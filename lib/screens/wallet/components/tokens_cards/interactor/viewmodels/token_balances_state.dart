part of 'token_balances_bloc.dart';

class TokenBalancesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<TokenBalanceViewModel> availableTokens;
  final int selectedIndex;

  TokenBalanceViewModel get selectedToken => availableTokens[selectedIndex];

  const TokenBalancesState({
    required this.pageState,
    this.errorMessage,
    required this.availableTokens,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, availableTokens, selectedIndex];

  TokenBalanceViewModel? balanceViewModelForToken(String tokenModelID) =>
      availableTokens.firstWhereOrNull((element) => element.token.id == tokenModelID);

  TokenBalancesState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<TokenBalanceViewModel>? availableTokens,
    int? selectedIndex,
  }) {
    return TokenBalancesState(
        pageState: pageState ?? this.pageState,
        errorMessage: errorMessage,
        availableTokens: availableTokens ?? this.availableTokens,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  factory TokenBalancesState.initial() {
    return TokenBalancesState(
      selectedIndex: 0,
      pageState: PageState.initial,
      availableTokens: [TokenBalanceViewModel(seedsToken, null)],
    );
  }
}
