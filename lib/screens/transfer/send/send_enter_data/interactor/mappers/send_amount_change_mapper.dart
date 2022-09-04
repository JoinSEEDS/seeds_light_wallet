import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/domain-shared/result_to_state_mapper.dart';
import 'package:seeds/screens/transfer/send/send_enter_data/interactor/viewmodels/send_enter_data_bloc.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class SendAmountChangeMapper extends StateMapper {
  SendEnterDataState mapResultToState(SendEnterDataState currentState, RatesState rateState, String quantity) {
    final double parsedQuantity = double.tryParse(quantity) ?? 0;

    final tokenAmount = TokenDataModel(parsedQuantity, token: settingsStorage.selectedToken);
    final selectedFiat = settingsStorage.selectedFiatCurrency;
    final fiatAmount = rateState.tokenToFiat(tokenAmount, selectedFiat);

    final double currentAvailable = currentState.availableBalance?.amount ?? 0;

    final double insufficiency =
        currentState.availableBalance?.asFormattedString() == tokenAmount.asFormattedString() ? 0.0 :
        parsedQuantity - currentAvailable;

    return currentState.copyWith(
      fiatAmount: fiatAmount,
      isNextButtonEnabled: parsedQuantity > 0 && !settingsStorage.selectedToken.blockAmount(insufficiency),
      tokenAmount: tokenAmount,
      showAlert: settingsStorage.selectedToken.warnAmount(insufficiency),
    );
  }
}
