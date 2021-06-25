import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/available_tokens_state.dart';

class AvailableTokensStateMapper {

  AvailableTokensState mapResultToState(AvailableTokensState currentState, List<TokenModel> tokens, List<Result> results) {

    assert(tokens.length == results.length, "invalid results");
    
    List<TokenModel> available = [];

    // TODO: get whitelist and blacklist from settings

    List<TokenModel> whitelist = [SeedsToken];
    List<TokenModel> blacklist = []; // user has chosen to hide this token

    for(int i=0; i<tokens.length; i++){
      var token = tokens[i];
      var result = results[i];

      if (whitelist.contains(token)) {
        available.add(token);
      } else if (!blacklist.contains(token)) {
        if (results[i].isError) {
          print("error loading ${token.symbol}");
        } else {
          BalanceModel balance = result.asValue?.value as BalanceModel;
          if (balance.quantity > 0) {
            available.add(token);
          } else {
            print("excluding ${token.symbol} - no balance");
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
