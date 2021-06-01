import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/explore_screens/invite/interactor/viewmodels/invite_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';
import 'package:seeds/i18n/invite.i18n.dart';

class SeedsAmountChangeMapper extends StateMapper {
  InviteState mapResultToState(InviteState currentState, RatesState rateState, String quantity) {
    double parsedQuantity = double.tryParse(quantity) ?? 0;
    double currentAvailable = currentState.availableBalance?.quantity ?? 0;

    String? alertMessage = _handleAlertMessage(currentAvailable, parsedQuantity);

    return currentState.copyWith(
      fiatAmount: rateState.fromSeedsToFiat(parsedQuantity, settingsStorage.selectedFiatCurrency).fiatFormatted,
      isCreateInviteButtonEnabled: alertMessage == null && parsedQuantity > 0,
      quantity: parsedQuantity,
      alertMessage: alertMessage,
    );
  }

  String? _handleAlertMessage(double availableAmount, double inputAmount) {
    if (inputAmount > 0 && inputAmount > availableAmount) {
      return 'Not enough balance'.i18n;
    } else if (inputAmount > 0 && inputAmount < 5) {
      return 'Minimum 5 Seeds required to invite'.i18n;
    } else {
      return null;
    }
  }
}
