import 'package:seeds/v2/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/v2/datasource/remote/model/rate_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';

class RatesStateMapper extends StateMapper {
  RatesState mapResultToState(RatesState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      print('RatesStateMapper mapResultsToState length=${results.length}');
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue.value).toList();
      RateModel rate = values.firstWhere((i) => i is RateModel, orElse: () => null);
      List<FiatRateModel> fiatRates = values.whereType<FiatRateModel>().toList();
      FiatRateModel fiatRate;
      if (fiatRates.length > 1 && fiatRates.isNotEmpty) {
        fiatRate = fiatRates[0];
        fiatRate.merge(fiatRates[1]);
      } else if (fiatRates.isNotEmpty) {
        fiatRate = fiatRates[0];
      }
      return currentState.copyWith(rate: rate, fiatRate: fiatRate);
    }
  }
}
