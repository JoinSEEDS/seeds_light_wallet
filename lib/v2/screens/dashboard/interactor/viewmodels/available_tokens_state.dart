import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';

class AvailableTokensState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final List<TokenBalanceModel> availableTokens;

  const AvailableTokensState({
    required this.pageState,
    this.errorMessage,
    required this.availableTokens,
  });

  @override
  List<Object?> get props => [pageState, errorMessage, availableTokens];

  AvailableTokensState copyWith({
    PageState? pageState,
    String? errorMessage,
    List<TokenBalanceModel>? availableTokens,
  }) {
    return AvailableTokensState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      availableTokens: availableTokens ?? this.availableTokens,
    );
  }

  factory AvailableTokensState.initial() {
    return const AvailableTokensState(pageState: PageState.initial, availableTokens: [TokenBalanceModel(SeedsToken, null)]);
  }
}
