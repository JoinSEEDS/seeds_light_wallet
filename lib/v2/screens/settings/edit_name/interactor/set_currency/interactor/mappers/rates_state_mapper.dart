import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/state_mapper.dart';
import 'package:seeds/v2/screens/settings/edit_name/interactor/set_currency/interactor/viewmodels/set_currency_state.dart';

class RatesStateMapper extends StateMapper<FiatRateModel, SetCurrencyState> {
  @override
  SetCurrencyState mapToState(SetCurrencyState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      return currentState.copyWith(pageState: PageState.success, fiatRateModel: result.asValue.value);
    }
  }
}
