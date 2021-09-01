import 'package:seeds/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/datasource/local/models/fiat_data_model.dart';
import 'package:seeds/datasource/local/models/token_data_model.dart';
import 'package:seeds/datasource/remote/model/token_model.dart';

extension RatesStateExtensions on RatesState {
  FiatDataModel? tokenToFiat(TokenDataModel tokenAmount, String currencySymbol) {
    // Convert seeds to USD
    if (tokenAmount.symbol == SeedsToken.symbol) {
      final double? usdValue = rate?.seedsToUSD(tokenAmount.amount);
      if (usdValue != null) {
        // Convert the seeds (USD amount) in the new currency
        final double? res = fiatRate?.usdToCurrency(usdValue, currencySymbol);
        return res != null ? FiatDataModel(res, fiatSymbol: currencySymbol) : null;
      }
    } else if (tokenAmount.symbol == HusdToken.symbol) {
      final double usdValue = tokenAmount.amount;
      final double? res = fiatRate?.usdToCurrency(usdValue, currencySymbol);
      return res != null ? FiatDataModel(res, fiatSymbol: currencySymbol) : null;
    }
    return null;
  }

  TokenDataModel? fiatToToken(FiatDataModel fiatAmount, String tokenSymbol) {
    // Convert seeds to USD
    final double? usdValue = fiatRate?.currencyToUSD(fiatAmount.amount, fiatAmount.symbol);
    if (usdValue != null) {
      if (tokenSymbol == SeedsToken.symbol) {
        final double? seedsValue = rate?.usdToSeeds(usdValue);
        if (seedsValue != null) {
          return TokenDataModel(seedsValue);
        }
      } else if (tokenSymbol == HusdToken.symbol) {
        return TokenDataModel(usdValue, token: HusdToken);
      }
    }
    return null;
  }

  /// Returns a double representing the amount of given fiat currency in seeds
  double fromFiatToSeeds(double currencyAmount, String currencySymbol) {
    if (currencySymbol == "USD") {
      return rate?.usdToSeeds(currencyAmount) ?? double.nan;
    } else {
      // Convert that currency value to USD value
      final double? usdValue = fiatRate?.currencyToUSD(currencyAmount, currencySymbol);
      if (usdValue != null) {
        // Convert the currency (USD amount) in seeds
        return rate?.usdToSeeds(usdValue) ?? double.nan;
      } else {
        return double.nan;
      }
    }
  }
}
