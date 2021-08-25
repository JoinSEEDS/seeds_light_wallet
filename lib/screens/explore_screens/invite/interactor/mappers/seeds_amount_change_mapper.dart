import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/explore_screens/invite/interactor/viewmodels/invite_state.dart';
import 'package:seeds/utils/rate_states_extensions.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/explore_screens/invite/invite.i18n.dart';

class SeedsAmountChangeMapper extends StateMapper {
  InviteState mapResultToState(InviteState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;
    final double currentAvailable = currentState.availableBalance?.amount ?? 0;

    final String? alertMessage = _handleAlertMessage(currentAvailable, parsedQuantity);

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
