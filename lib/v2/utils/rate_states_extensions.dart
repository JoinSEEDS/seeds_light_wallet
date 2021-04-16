import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/v2/blocs/rates/viewmodels/rates_state.dart';

extension RatesStateExtensions on RatesState {
  double _seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = rate?.toUSD(seedsValue) ?? 0;
    return fiatRate?.usdTo(usdValue, currencySymbol) ?? 0;
  }

  double _toSeeds(double currencyValue, String currencySymbol) {
    var usdValue = fiatRate?.toUSD(currencyValue, currencySymbol) ?? 0;
    return rate?.toSeeds(usdValue) ?? 0;
  }

  String currencyString(double seedsAmount, String currencySymbol) {
    return _seedsTo(seedsAmount, currencySymbol).fiatFormatted! + ' ' + currencySymbol;
  }

  String seedsString(double currencyAmount, String currencySymbol) {
    return _toSeeds(currencyAmount, currencySymbol).seedsFormatted! + ' SEEDS';
  }
}
