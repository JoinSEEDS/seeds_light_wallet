import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class SendEnterDataStateMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(
      SendEnterDataPageState currentState, Result result, RatesState rateState, String quantity) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, error: "Error loading current balance");
    } else {
      BalanceModel balance = result.asValue!.value as BalanceModel;
      double parsedQuantity = double.parse(quantity);

      var selectedFiat = settingsStorage.selectedFiatCurrency;
      String fiatAmount = rateState.fromSeedsToFiat(parsedQuantity, selectedFiat);

      String availableBalanceFiat = rateState.fromSeedsToFiat(balance.quantity, selectedFiat);

      return currentState.copyWith(
          pageState: PageState.success,
          fiatAmount: fiatAmount,
          availableBalance: balance.formattedQuantity,
          availableBalanceFiat: availableBalanceFiat,
          error: null,
          balance: balance);
    }
  }
}
