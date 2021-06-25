import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/token_balances_state.dart';

class TokenBalancesStateMapper {

  TokenBalancesState mapResultToState(TokenBalancesState currentState, List<TokenModel> tokens, List<Result> results) {

    assert(tokens.length == results.length, "invalid results");
    
    List<TokenBalanceModel> available = [];

    // TODO: get whitelist and blacklist from settings

    List<TokenModel> whitelist = [SeedsToken];
    List<TokenModel> blacklist = []; // user has chosen to hide this token

    for(int i=0; i<tokens.length; i++){
      var token = tokens[i];
      var result = results[i];
      bool whitelisted = whitelist.contains(token);
      if (whitelisted || !blacklist.contains(token)) {
        if (results[i].isError) {
          print("error loading ${token.symbol}");
          if (whitelisted) {
            available.add(TokenBalanceModel(token, null, errorLoading: true));
          }  
        } else {
          BalanceModel balance = result.asValue?.value as BalanceModel;
          if (whitelisted || balance.quantity > 0) {
            available.add(TokenBalanceModel(token, balance));
          } 
        }
      }

    }

    return currentState.copyWith(
      pageState: PageState.success,
      availableTokens: available
    );
  }
}
