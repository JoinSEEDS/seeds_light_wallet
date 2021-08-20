import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/balance_model.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/explore_screens/invite/invite.i18n.dart';

class UserBalanceStateMapper extends StateMapper {
  InviteState mapResultToState(InviteState currentState, Result result, RatesState rateState) {
    if (result.isError) {
      return currentState.copyWith(pageState: PageState.failure, errorMessage: "Error loading current balance".i18n);
    } else {
      final BalanceModel balance = result.asValue!.value as BalanceModel;
      final String selectedFiat = settingsStorage.selectedFiatCurrency;

      return currentState.copyWith(
        pageState: PageState.success,
        fiatAmount: rateState.fromSeedsToFiat(0, selectedFiat).fiatFormatted,
        availableBalance: balance,
        availableBalanceFiat: rateState.fromSeedsToFiat(balance.quantity, selectedFiat).fiatFormatted,
      );
    }
  }
}
