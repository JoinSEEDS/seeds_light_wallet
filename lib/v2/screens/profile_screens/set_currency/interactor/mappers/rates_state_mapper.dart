import 'package:seeds/v2/datasource/local/models/currency.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/viewmodels/set_currency_state.dart';

class RateStateMapper extends StateMapper {
  SetCurrencyState mapResultToState(SetCurrencyState currentState, Map<String, double> rates) {
    if (rates == null) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      // System available currencies (35 at this moment)
      final loaded = List<String>.from(rates.keys);
      // All most_traded_currencies (93 at this moment) to a Currency objects
      final allCurrencies = currencies.map((currency) => Currency.from(json: currency)).toList();
      // Get only system available currencies from allCurrencies
      var availables = allCurrencies.where((i) => loaded.contains(i.flag)).toList();

      return currentState.copyWith(
        pageState: PageState.success,
        availableCurrencies: availables,
        queryCurrenciesResults: availables,
      );
    }
  }
}
