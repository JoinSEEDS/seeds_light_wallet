import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balance_view_model.dart';
import 'package:seeds/v2/screens/wallet/components/tokens_cards/interactor/viewmodels/token_balances_state.dart';

class TokenBalancesStateMapper {
  TokenBalancesState mapResultToState(TokenBalancesState currentState, List<TokenModel> tokens, List<Result> results) {
    assert(tokens.length == results.length, "invalid results");

    List<TokenBalanceViewModel> available = [];

    Iterable<TokenModel> whitelist =
        TokenModel.AllTokens.where((element) => settingsStorage.tokensWhitelist.contains(element.id));

    print("whitelist: ");
    print(whitelist);

    List<TokenModel> blacklist = []; // user has chosen to hide this token

    List<String> newWhitelist = [];

    for (int i = 0; i < tokens.length; i++) {
      var token = tokens[i];
      var result = results[i];
      bool whitelisted = whitelist.contains(token);
      if (whitelisted || !blacklist.contains(token)) {
        if (results[i].isError) {
          print("error loading ${token.symbol} - show existing balance.");
          var existingBalance = currentState.balanceViewModelForToken(token.id);
          if (existingBalance != null || whitelisted) {
            var viewModel = existingBalance ?? TokenBalanceViewModel(token, null, errorLoading: true);
            available.add(viewModel);
            newWhitelist.add(token.id);
          }
        } else {
          BalanceModel balance = result.asValue?.value as BalanceModel;
          if (whitelisted || balance.quantity > 0) {
            available.add(TokenBalanceViewModel(token, balance));
            newWhitelist.add(token.id);
          }
        }
      }
    }

    settingsStorage.tokensWhitelist = newWhitelist;

    print("NEW whitelist: ");
    print(whitelist);

    return currentState.copyWith(pageState: PageState.success, availableTokens: available);
  }
}
