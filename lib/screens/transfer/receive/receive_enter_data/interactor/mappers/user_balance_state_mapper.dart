import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/receive/receive_enter_data/interactor/viewmodels/receive_enter_data_bloc.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class UserBalanceStateMapper extends StateMapper {
  ReceiveEnterDataState mapResultToState(ReceiveEnterDataState currentState, Result<BalanceModel> result) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance");
    } else {
      final balance = result.asValue!.value;
      final availableBalance = TokenDataModel.fromSelected(balance.quantity);
      final String selectedFiat = settingsStorage.selectedFiatCurrency;
      final RatesState rateState = currentState.ratesState;
      return currentState.copyWith(
        pageState: PageState.success,
        availableBalanceFiat: rateState.tokenToFiat(availableBalance, selectedFiat),
        availableBalanceToken: availableBalance,
      );
    }
  }
}
