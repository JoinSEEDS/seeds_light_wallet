import 'package:seeds/v2/datasource/local/models/currency.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/profile_screens/set_currency/interactor/viewmodels/set_currency_state.dart';

class RateStateMapper extends StateMapper {
  SetCurrencyState mapResultToState(SetCurrencyState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: result.asError.error.toString());
    } else {
      // System available currencies (33 at this moment)
      final loaded = List<String>.from(result.asValue.value.ratesPerUSD.keys);
      // All most_traded_currencies (93 at this moment) to a Currency objects
      final allCurrencies = currencies.map((currency) => Currency.from(json: currency)).toList();
      // Get only system available currencies from allCurrencies
      var availables = allCurrencies.where((i) => loaded.contains(i.flag)).toList();
      // Get target currency
      final tarjet = availables.singleWhere((i) => i.code == currentState.currentQuery);
      // remove and inserte target as first result
      availables.removeWhere((i) => i.code == currentState.currentQuery);
      availables.insert(0, tarjet);

      return currentState.copyWith(
        pageState: PageState.success,
        availableCurrencies: availables,
      );
    }
  }
}
