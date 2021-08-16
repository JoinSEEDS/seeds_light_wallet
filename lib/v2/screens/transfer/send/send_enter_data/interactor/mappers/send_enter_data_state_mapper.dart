import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/balance_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';

class SendEnterDataStateMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(
      SendEnterDataPageState currentState, Result result, RatesState rateState, String quantity) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final BalanceModel balance = result.asValue!.value as BalanceModel;
      final double parsedQuantity = double.parse(quantity);

      final hasFiat = rateState.canConvert(currentState.token);

      if (hasFiat) {
        final selectedFiat = settingsStorage.selectedFiatCurrency;
        final String fiatAmount = rateState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted;
        final String availableBalanceFiat = rateState.fromSeedsToFiat(balance.quantity, selectedFiat).fiatFormatted;

        return currentState.copyWith(
          pageState: PageState.success,
          balance: balance,
          availableBalance: balance.formattedQuantity,
          fiatAmount: fiatAmount,
          availableBalanceFiat: availableBalanceFiat,
        );
      } else {
        return currentState.copyWith(
          pageState: PageState.success,
          balance: balance,
          availableBalance: balance.formattedQuantity,
        );
      }
    }
  }
}
