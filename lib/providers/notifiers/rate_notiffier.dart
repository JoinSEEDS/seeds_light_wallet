

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds/models/models.dart';
import 'package:seeds/providers/services/http_service.dart';
import 'package:seeds/utils/double_extension.dart';
import 'package:seeds/i18n/wallet.i18n.dart';

const String SEEDS = 'SEEDS';

class RateNotifier extends ChangeNotifier with CurrencyConverter {
  RateModel? rate;
  FiatRateModel? fiatRate;
  DateTime lastUpdated = DateTime.now().subtract(const Duration(hours: 1));

  HttpService? _http;

  static RateNotifier of(BuildContext context, {bool listen = false}) =>
      Provider.of<RateNotifier>(context, listen: listen);

  void update({HttpService? http}) {
    _http = http;
  }

  Future<void> fetchRate() {
    if (DateTime.now().isAfter(lastUpdated.add(const Duration(hours: 1)))) {
      return Future.wait([
        _http!.getUSDRate(),
        _http!.getFiatRates(),
      ]).then((result) {
        rate = result[0] as RateModel?;
        fiatRate = result[1] as FiatRateModel?;
        notifyListeners();
      });
    } else {
      return Future.value([rate, fiatRate]);
    }
  }

  @override
  double seedsTo(double seedsValue, String currencySymbol) {
    var usdValue = rate?.toUSD(seedsValue) ?? 0;
    return fiatRate?.usdTo(usdValue, currencySymbol) ?? 0;
  }

  @override
  double toSeeds(double? currencyValue, String? currencySymbol) {
    var usdValue = fiatRate?.toUSD(currencyValue, currencySymbol) ?? 0;
    return rate?.toSeeds(usdValue) ?? 0;
  }

  String currencyString(double seedsAmount, String currencySymbol) {
    return seedsTo(seedsAmount, currencySymbol).fiatFormatted! + ' ' + currencySymbol;
  }

  String seedsString(double currencyAmount, String currencySymbol) {
    return toSeeds(currencyAmount, currencySymbol).seedsFormatted! + ' SEEDS';
  }

  String amountToString(double amount, String currency, {bool asSeeds = false}) {
    if (rate == null || fiatRate == null) {
      return '';
    } else {
      if (rate?.error ?? false) {
        return 'Exchange rate load error'.i18n;
      }
      return asSeeds ? seedsString(amount, currency) : currencyString(amount, currency);
    }
  }
}
