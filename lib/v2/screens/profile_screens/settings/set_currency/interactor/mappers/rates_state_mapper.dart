import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/settings/set_currency/interactor/viewmodels/set_currency_state.dart';

class RateStateMapper extends StateMapper {
  SetCurrencyState mapResultToState(SetCurrencyState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      var list = List<String>.from(result.asValue.value.ratesPerUSD.keys);
      list.removeWhere((i) => i == currentState.currentQuery);
      list.insert(0, currentState.currentQuery);

      return currentState.copyWith(
        pageState: PageState.success,
        fiatRateModel: result.asValue.value,
        currencyResult: list,
      );
    }
  }
}
