import 'package:seeds/blocs/rates/viewmodels/rates_bloc.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/rate_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

extension RatesStateExtensions on RatesState {
  FiatDataModel? tokenToFiat(TokenDataModel tokenAmount, String currencySymbol) {
    // Convert token to USD
    final RateModel? rateModel = rates?[tokenAmount.symbol];
    if (rateModel != null) {
      final double? usdValue = rateModel.tokenToUSD(tokenAmount.amount);

      if (usdValue != null && currencySymbol == 'USD') {
        return FiatDataModel(usdValue, fiatSymbol: currencySymbol);
      } else if (usdValue != null) {
        // Convert the seeds (USD amount) in the new currency
        final double? res = fiatRate?.usdToCurrency(usdValue, currencySymbol);
        return res != null ? FiatDataModel(res, fiatSymbol: currencySymbol) : null;
      }
    }
    return null;
  }

  TokenDataModel? fiatToToken(FiatDataModel fiatAmount, String tokenSymbol) {
    // Convert seeds to USD
    final double? usdValue = fiatRate?.currencyToUSD(fiatAmount.amount, fiatAmount.symbol);
    if (usdValue != null) {
      final RateModel? rateModel = rates?[tokenSymbol];
      if (rateModel != null) {
        final double? tokenValue = rateModel.usdToToken(usdValue);
        if (tokenValue != null) {
          return TokenDataModel(tokenValue, token: TokenModel.fromSymbol(tokenSymbol));
        }
      }
    }
    return null;
  }
}
