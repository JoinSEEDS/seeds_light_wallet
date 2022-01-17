import 'package:seeds/datasource/local/models/currency.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/profile_screens/set_currency/interactor/viewmodels/set_currency_bloc.dart';

class RateStateMapper extends StateMapper {
  SetCurrencyState mapResultToState(SetCurrencyState currentState, Map<String?, num> rates) {
    if (rates.isEmpty) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch rates...');
    } else {
      final Map<String?, String?> available = rates.map((key, value) => MapEntry(key, key));
      final prefix = List<String>.from(topCurrencies.where((i) {
        if (available[i] != null) {
          available.remove(i);
          return true;
        }
        return false;
      }));
      List<String> list = List<String>.from(available.keys);
      list.sort();
      list = prefix + list;
      final currencies = List.of(list.map((i) => Currency(i, allCurrencies[i] ?? "")));

      return currentState.copyWith(
        pageState: PageState.success,
        availableCurrencies: currencies,
        queryCurrenciesResults: currencies,
      );
    }
  }
}
