import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';
import 'package:collection/collection.dart';

class TokenBalancesState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<TokenBalanceViewModel> availableTokens;
  final int selectedIndex;

  const TokenBalancesState({
    required this.pageState,
    this.errorMessage,
    required this.availableTokens,
    this.selectedIndex = 0,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, availableTokens];

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
    return const TokenBalancesState(
      pageState: PageState.initial,
      availableTokens: [TokenBalanceViewModel(SeedsToken, null)],
    );
  }
}
