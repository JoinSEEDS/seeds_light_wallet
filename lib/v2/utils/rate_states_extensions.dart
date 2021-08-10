import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';

extension RatesStateExtensions on RatesState {
  double _seedsTo(double seedsValue, String currencySymbol) {
    final double? usdValue = rate?.toUSD(seedsValue);

    if (usdValue != null) {
      return fiatRate?.usdTo(usdValue, currencySymbol) ?? double.nan;
    } else {
      return double.nan;
    }
  }

  double _toSeeds(double currencyValue, String currencySymbol) {
    if (currencySymbol == "USD") {
      return rate?.toSeeds(currencyValue) ?? double.nan;
    } else {
      final double? currencyRate = fiatRate?.usdTo(currencyValue, currencySymbol);

      if (currencyRate != null) {
        return rate?.toSeeds(currencyRate) ?? double.nan;
      } else {
        return double.nan;
      }
    }
  }

  /// Returns a double that represents the amount of seeds in a given fiat currency
  double fromSeedsToFiat(double seedsAmount, String currencySymbol) {
    return _seedsTo(seedsAmount, currencySymbol);
  }

  /// Returns a double representing the amount of given fiat currency in seeds
  double fromFiatToSeeds(double currencyAmount, String currencySymbol) {
    return _toSeeds(currencyAmount, currencySymbol);
  }
}
