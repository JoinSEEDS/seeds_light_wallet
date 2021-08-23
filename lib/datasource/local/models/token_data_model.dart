import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

class TokenDataModel extends AmountDataModel {
  TokenDataModel(double amount, {required TokenModel token})
      : super(
          amount: amount,
          symbol: token.symbol,
          precision: token.precision,
        );

  static TokenDataModel? from(double? amount, {required TokenModel token}) =>
      amount != null ? TokenDataModel(amount, token: token) : null;
}
