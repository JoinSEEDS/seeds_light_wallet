import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

const String SEEDS = "SEEDS";

class RateNotifier extends ChangeNotifier {
  RateModel rate;
  FiatRateModel fiatRate;
  DateTime lastUpdated = DateTime.now().subtract(Duration(hours: 1));

  HttpService _http;

  static of(BuildContext context, {bool listen = false}) =>
      Provider.of<RateNotifier>(context, listen: listen);

  void update({HttpService http}) {
    _http = http;
  }

  Future<void> fetchRate() {
    if (DateTime.now().isAfter(lastUpdated.add(Duration(hours: 1)))) {
      return Future.wait(
      [
        _http.getUSDRate(),
        _http.getFiatRates()
      ]).then((result) {
        rate = result[0];
        fiatRate = result[1];
        notifyListeners();
      });
    } else {
      return Future.value([rate, fiatRate]);
    }
  }

  double seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = rate.toUSD(seedsValue);
    return fiatRate.usdTo(usdValue, currencySymbol);
    
  }
  double toSeeds(double currencyValue, String currencySymbol) {
    var usdValue = fiatRate.toUSD(currencyValue, currencySymbol);
    return rate.toSeeds(usdValue);
  }

  String currencyString(double seedsAmount, String currencySymbol) {
    return seedsTo(seedsAmount, currencySymbol).fiatFormatted + " " + currencySymbol;
  }

  String seedsString(double currencyAmount, String currencySymbol) {
    return toSeeds(currencyAmount, currencySymbol).seedsFormatted + " SEEDS";
  }

  String amountToString(double amount, String currency, {bool asSeeds = false}) {
    if (rate == null || fiatRate == null) {
      return "";
    } else {
      if (rate.error) {
        return "Exchange rate load error".i18n;
      }
      return asSeeds ? seedsString(amount, currency) : currencyString(amount, currency);
    }
  }

}
