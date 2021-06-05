import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/receive_screens/receive_enter_data/interactor/viewmodels/receive_enter_data_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class UserBalanceStateMapper extends StateMapper {
  ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      BalanceModel balance = result.asValue!.value as BalanceModel;
      String? selectedFiat = settingsStorage.selectedFiatCurrency;
      RatesState rateState = currentState.ratesState;

      return currentState.copyWith(
          pageState: PageState.success,
          availableBalance: balance,
          availableBalanceFiat: rateState.fromSeedsToFiat(balance.quantity, selectedFiat).fiatFormatted,
          availableBalanceSeeds: balance.quantity.seedsFormatted);
    }
  }
}
