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
      results.retainWhere((Result i) => i.isValue);
      var values = results.map((Result i) => i.asValue!.value).toList();
      RateModel? rate = values.firstWhere((i) => i is RateModel, orElse: () => null);
      FiatRateModel? fiatRate = values.firstWhere((i) => i is FiatRateModel, orElse: () => null);
      return currentState.copyWith(rate: rate, fiatRate: fiatRate);
    }
  }
}
