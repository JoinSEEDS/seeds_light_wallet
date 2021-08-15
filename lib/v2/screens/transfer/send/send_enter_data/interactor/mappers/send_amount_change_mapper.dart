import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/v2/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_state.dart';
import 'package:seeds/v2/utils/rate_states_extensions.dart';
import 'package:seeds/v2/utils/double_extension.dart';

class SendAmountChangeMapper extends StateMapper {
  SendEnterDataPageState mapResultToState(SendEnterDataPageState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;

    final selectedFiat = settingsStorage.selectedFiatCurrency;
    final String fiatAmount = rateState.fromSeedsToFiat(parsedQuantity, selectedFiat).fiatFormatted;

    final double currentAvailable = currentState.balance?.quantity ?? 0;

    return currentState.copyWith(
      fiatAmount: fiatAmount,
      isNextButtonEnabled: parsedQuantity > 0 && parsedQuantity < currentAvailable,
      quantity: parsedQuantity,
      showAlert: parsedQuantity > currentAvailable,
    );
  }
}
