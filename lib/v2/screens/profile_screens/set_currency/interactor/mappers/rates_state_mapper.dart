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
      final loaded = List<String>.from(result.asValue.value.rates.keys);

      // TODO-NIK: The code above was throwing at runtime because I had renamed ratesPerUSD to "rates"
      // Can we somehow change this so that this would get caught at compile time?
      // I am guessing it's because this is a non-specific class here so the compiler is unaware of the class
      // of the object it's calling the member of.
      // I also don't like direct member access, that is unclearn
      // I did a quick test replacing it with the - already existing - accessor "currencies()" but that did
      // not work  -Nik


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
