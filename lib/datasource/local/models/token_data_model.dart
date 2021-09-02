import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/rate_states_extensions.dart';
import 'package:seeds/utils/double_extension.dart';

class TokenDataModel extends AmountDataModel {
  TokenDataModel(double amount, {TokenModel token = SeedsToken})
      : super(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        );

  static TokenDataModel? from(double? amount, {TokenModel token = SeedsToken}) =>
      amount != null ? TokenDataModel(amount, token: token) : null;

  static TokenDataModel fromSelected(double amount) => TokenDataModel(amount, token: settingsStorage.selectedToken);

  // formatted number, no symbol, example "10.00"
  String amountString() {
    return amount.seedsFormatted;
  }

  // number and symbol, for display purposes, example "10.00 SEEDS"
  String amountStringWithSymbol() {
    return "${amount.seedsFormatted} $symbol";
  }

  TokenDataModel copyWith(double amount) {
    return TokenDataModel(amount, token: TokenModel.fromSymbol(symbol));
  }
}

extension FormatterTokenModel on TokenDataModel {
// Convenience method: directly get a fiat converted string from a token model
// tokenModel.fiatString(...) => "12.34 EUR"
  String? fiatString(RatesState rateState) {
    return rateState.tokenToFiat(this, settingsStorage.selectedFiatCurrency)?.asFormattedString();
  }
}
