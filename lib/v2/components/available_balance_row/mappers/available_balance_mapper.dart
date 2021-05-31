import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/components/available_balance_row/interactor/viewmodels/available_balance_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class AvailableBalanceStateMapper extends StateMapper {
  AvailableBalanceState mapResultToState(
    AvailableBalanceState currentState,
    Result result,
    RatesState rateState,
  ) {
    if (result.isError) {
      return currentState.copyWith(
          //    pageState: PageState.failure,
          //  error: "Error loading current balance"
          );
    } else {
      BalanceModel balance = result.asValue!.value as BalanceModel;
      String availableSeeds = balance.formattedQuantity;

      var selectedFiat = settingsStorage.selectedFiatCurrency;

      String availableBalanceFiat = rateState.fromSeedsToFiat(balance.quantity, selectedFiat).fiatFormatted;

      return currentState.copyWith(seedsAmount: availableSeeds, seedsToFiat: availableBalanceFiat);
    }
  }
}
