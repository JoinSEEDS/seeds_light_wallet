class FiatRateModel {
  Map<String?, num> rates;
  String? base;

  FiatRateModel(this.rates, {this.base = "USD"});

  factory FiatRateModel.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      final model = FiatRateModel(Map<String, num>.from(json["rates"] as Map), base: json["base"] as String);
      model.rebase("USD");
      return model;
    } else {
      return FiatRateModel({});
    }
  }

  double? usdToCurrency(double usdValue, String currency) {
    final num? rate = rates[currency];
    if (rate != null) {
      return usdValue * rate;
    } else {
      return null;
    }
  }

  double? currencyToUSD(double currencyValue, String currency) {
    final num? rate = rates[currency];
    if (rate != null) {
      return rate > 0 ? currencyValue / rate : 0;
    } else {
      return null;
    }
  }

  void rebase(String symbol) {
    final rate = rates[symbol];
    if (rate != null) {
      rates[base] = 1.0;
      base = symbol;
      rates = rates.map((key, value) => MapEntry(key, value / rate));
      rates[base] = 1.0;
    } else {
      print("error - can't rebase to $symbol");
    }
  }
}
