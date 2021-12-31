import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class SendEnterDataStateMapper extends StateMapper {
  SendEnterDataState mapResultToState(
      SendEnterDataState currentState, Result<BalanceModel> result, RatesState rateState, String quantity) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final BalanceModel balance = result.asValue!.value;
      final availableBalance = TokenDataModel(balance.quantity, token: settingsStorage.selectedToken);

      return currentState.copyWith(
        pageState: PageState.success,
        availableBalance: availableBalance,
        availableBalanceFiat: rateState.tokenToFiat(availableBalance, settingsStorage.selectedFiatCurrency),
      );
    }
  }
}
