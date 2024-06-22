import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';
import 'package:seeds/screens/explore_screens/invite/invite_errors.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class UserBalanceStateMapper extends StateMapper {
  InviteState mapResultToState(InviteState currentState, Result<BalanceModel> result, RatesState rateState) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: InviteError.errorLoadingBalance);
    } else {
      final BalanceModel balance = result.asValue!.value;
      final availableBalance = TokenDataModel(balance.quantity, token: seedsToken);
      final String selectedFiat = settingsStorage.selectedFiatCurrency;

      return currentState.copyWith(
        pageState: PageState.success,
        availableBalance: availableBalance,
        availableBalanceFiat: rateState.tokenToFiat(availableBalance, selectedFiat),
      );
    }
  }
}
