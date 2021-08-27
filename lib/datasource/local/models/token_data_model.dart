import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class TokenDataModel extends AmountDataModel {
  TokenDataModel(double amount, {required TokenModel token})
      : super(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        );

  static TokenDataModel fromSeeds(double amount) => TokenDataModel(amount, token: SeedsToken);

  static TokenDataModel? fromSeedsOrNull(double? amount) =>
      amount != null ? TokenDataModel(amount, token: SeedsToken) : null;

  static TokenDataModel fromSelected(double amount) => TokenDataModel(amount, token: settingsStorage.selectedToken);
}

extension FormatterTokenModel on TokenDataModel {
// Convenience method: directly get a fiat converted string from a token model
// tokenModel.fiatString(...) => "12.34 EUR"
  String? fiatString(RatesState rateState) {
    return rateState.tokenToFiat(this, settingsStorage.selectedFiatCurrency)?.asFormattedString();
  }
}
