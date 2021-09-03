import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/rate_states_extensions.dart';
import 'package:seeds/utils/double_extension.dart';

class TokenDataModel {
  final double amount;
  final String symbol;
  final int precision;

  TokenDataModel({required this.amount, required this.symbol, required this.precision});

  TokenDataModel.from(double amount, {TokenModel token = SeedsToken})
      : this(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        );

  TokenDataModel.withParameters(double amount, {required TokenParameters tokenParams})
      : this(amount: amount, symbol: tokenParams.symbol, precision: tokenParams.precision);

  static TokenDataModel? fromOrNull(double? amount, {TokenModel token = SeedsToken}) =>
      amount != null ? TokenDataModel.from(amount, token: token) : null;

  String asFormattedString() {
    return "${amount.toStringAsFixed(precision)} $symbol";
  }

  // display formatted number, no symbol, example "10.00", "10,000,000.00"
  String amountString() {
    if (precision == 4) {
      return fourDigitNumberFormat.format(amount);
    } else if (precision == 2) {
      return twoDigitNumberFormat.format(amount);
    } else {
      return asFixedString();
    }
  }

  // display formatted number and symbol, example "10.00 SEEDS", "1,234.56 SEEDS"
  String amountStringWithSymbol() {
    return "${amountString()} $symbol";
  }

  TokenDataModel copyWith(double amount) {
    return TokenDataModel(amount: amount, symbol: symbol, precision: precision);
  }
}

extension FormatterTokenModel on TokenDataModel {
// Convenience method: directly get a fiat converted string from a token model
// tokenModel.fiatString(...) => "12.34 EUR"
  String? fiatString(RatesState rateState) {
    return rateState.tokenToFiat(this, settingsStorage.selectedFiatCurrency)?.asFormattedString();
  }
}
