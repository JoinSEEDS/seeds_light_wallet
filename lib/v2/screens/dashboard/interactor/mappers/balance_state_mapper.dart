import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/dashboard/interactor/viewmodels/balance_state.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class BalanceStateMapper {
  BalanceState mapResultToState(BalanceState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: 'Error getting balance for ${currentState.token.symbol}', cardDisplayText: "...");
    } else {
      BalanceModel balance = result.asValue?.value as BalanceModel;
      return currentState.copyWith(
        pageState: PageState.success, amount: balance.quantity, cardDisplayText: balance.quantity.seedsFormatted + " " + currentState.token.symbol);
    }
  }
}
