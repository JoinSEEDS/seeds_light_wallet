import 'package:seeds/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';

class RatesStateMapper extends StateMapper {
  RatesState mapResultToState(RatesState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      results.retainWhere((Result i) => i.isValue);
      final values = results.map((Result i) => i.asValue!.value).toList();
      final RateModel? rate = values.firstWhere((i) => i is RateModel, orElse: () => null);
      final FiatRateModel? fiatRate = values.firstWhere((i) => i is FiatRateModel, orElse: () => null);
      return currentState.copyWith(rate: rate, fiatRate: fiatRate);
    }
  }
}
