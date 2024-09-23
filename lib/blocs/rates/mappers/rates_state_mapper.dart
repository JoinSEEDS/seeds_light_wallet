import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/remote/model/fiat_rate_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';

class RatesStateMapper extends StateMapper {
  static const husdTokenId = 'Telos#husd.hypha#HUSD';
  static const telosTokenId = 'Telos#eosio.token#TLOS';
  static const seedsTokenId = 'Telos#token.seeds#SEEDS';
  RatesState mapResultToState(RatesState currentState, List<Result> results) {
    if (areAllResultsError(results)) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: 'Cannot fetch balance...');
    } else {
      /// note: we re-use existing conversion rates if we can't load new ones
      final RateModel? seedsRateModel = results[0].asValue?.value as RateModel? ?? currentState.rates?[seedsTokenId];
      final RateModel? telosRateModel = results[1].asValue?.value as RateModel? ?? currentState.rates?[telosTokenId];
      final rates = {
        husdTokenId: const RateModel(husdTokenId, 1),
      };
      if (seedsRateModel != null) {
        rates[seedsTokenId] = seedsRateModel;
      }
      if (telosRateModel != null) {
        rates[telosTokenId] = telosRateModel;
      }
      final FiatRateModel? fiatRate = results[2].asValue?.value as FiatRateModel?;
      return currentState.copyWith(rates: rates, fiatRate: fiatRate);
    }
  }
}
