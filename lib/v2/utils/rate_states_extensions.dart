import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/token_model.dart';
import 'package:seeds/v2/utils/double_extension.dart';

extension RatesStateExtensions on RatesState {
  /// Returns a double that represents the amount of seeds in a given fiat currency
  double fromSeedsToFiat(double seedsAmount, String currencySymbol) {
    // Convert seeds to USD
    final double? usdValue = rate?.seedsToUSD(seedsAmount);
    if (usdValue != null) {
      // Convert the seeds (USD amount) in the new currency
      return fiatRate?.usdToCurrency(usdValue, currencySymbol) ?? double.nan;
    } else {
      return double.nan;
    }
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

  /// Return a display string or "" if conversion is impossible
  String fiatValueString(TokenModel token, double? amount) {
    final fiatCurrency = settingsStorage.selectedFiatCurrency;
    if (amount != null && token == SeedsToken) {
      // Convert seeds to USD
      final double? usdValue = rate?.seedsToUSD(amount);
      if (usdValue != null && fiatRate != null) {
        // Convert the seeds (USD amount) in the new currency
        final double? fiatValue = fiatRate?.usdToCurrency(usdValue, fiatCurrency);
        if (fiatValue != null) {
          return "${fiatValue.fiatFormatted} $fiatCurrency";
        }
      }
      return "";
    }
    return "";
  }
}
