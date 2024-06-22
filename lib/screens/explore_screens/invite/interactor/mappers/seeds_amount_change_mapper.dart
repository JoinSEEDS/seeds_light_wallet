import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_bloc.dart';
import 'package:seeds/screens/explore_screens/invite/invite_errors.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class SeedsAmountChangeMapper extends StateMapper {
  InviteState mapResultToState(InviteState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final double currentAvailable = currentState.availableBalance?.amount ?? 0;

    final InviteError? alertMessage = _handleAlertMessage(currentAvailable, parsedQuantity);
    final tokenAmount = TokenDataModel(parsedQuantity, token: seedsToken);

    return currentState.copyWith(
      tokenAmount: tokenAmount,
      fiatAmount: rateState.tokenToFiat(tokenAmount, settingsStorage.selectedFiatCurrency),
      isCreateInviteButtonEnabled: alertMessage == null && parsedQuantity > 0,
      alertMessage: alertMessage,
    );
  }

  InviteError? _handleAlertMessage(double availableAmount, double inputAmount) {
    if (inputAmount > 0 && inputAmount > availableAmount) {
      return InviteError.noEnoughBalance;
    } else if (inputAmount > 0 && inputAmount < 5) {
      return InviteError.minimumSeedsRequired;
    } else {
      return null;
    }
  }
}
