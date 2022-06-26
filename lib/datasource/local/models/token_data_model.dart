import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/local/settings_storage.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/utils/rate_states_extensions.dart';

class TokenDataModel extends AmountDataModel {
  String? id;
  TokenDataModel(double amount, {TokenModel token = seedsToken})
      : super(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        ) { id = token.id; }

  static TokenDataModel? from(double? amount, {TokenModel token = seedsToken}) =>
      amount != null ? TokenDataModel(amount, token: token) : null;

  // ignore: prefer_constructors_over_static_methods
  static TokenDataModel fromSelected(double amount) => TokenDataModel(amount, token: settingsStorage.selectedToken);

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
    return TokenDataModel(amount, token: TokenModel.fromId(id!));
  }
}

extension FormatterTokenModel on TokenDataModel {
// Convenience method: directly get a fiat converted string from a token model
// tokenModel.fiatString(...) => "12.34 EUR"
  String? fiatString(RatesState rateState) {
    return rateState.tokenToFiat(this, settingsStorage.selectedFiatCurrency)?.asFormattedString();
  }
}
