import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';
import 'package:seeds/v2/constants/ui_constants.dart';

extension RatesStateExtensions on RatesState {
  double _seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = rate?.toUSD(seedsValue) ?? 0;
    return fiatRate?.usdTo(usdValue, currencySymbol) ?? 0;
  }

  double _toSeeds(double currencyValue, String currencySymbol) {
    if (currencySymbol == "USD") {
      return rate?.toSeeds(currencyValue) ?? 0;
    } else {
      var usdValue = fiatRate?.toUSD(currencyValue, currencySymbol) ?? 0;
      return rate?.toSeeds(usdValue) ?? 0;
    }
  }

  /// Returns a String that represents the amount of seeds in a given fiat currency
  String fromSeedsToFiat(double seedsAmount, String? currencySymbol) {
    var currencyCode = currencySymbol ?? currencyDefaultCode;
    return _seedsTo(seedsAmount, currencyCode).fiatFormatted!;
  }

  /// Returns a string representing the amount of given fiat currency in seeds
  String fromFiatToSeeds(double currencyAmount, String? currencySymbol) {
    var currencyCode = currencySymbol ?? currencyDefaultCode;
    return _toSeeds(currencyAmount, currencyCode).seedsFormatted!;
  }
}
