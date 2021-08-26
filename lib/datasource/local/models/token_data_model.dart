import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class TokenDataModel extends AmountDataModel {
  TokenDataModel(double amount, {TokenModel token = SeedsToken})
      : super(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        );

  static TokenDataModel? from(double? amount, {TokenModel token = SeedsToken}) =>
      amount != null ? TokenDataModel(amount, token: token) : null;
}

extension FormatterTokenModel on TokenDataModel {
  String? fiatString(RatesState rateState) {
    return rateState.tokenToFiat(this, settingsStorage.selectedFiatCurrency)?.asFormattedString();
  }
}
