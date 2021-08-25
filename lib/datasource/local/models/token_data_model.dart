import 'package:seeds/datasource/local/models/amount_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

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
