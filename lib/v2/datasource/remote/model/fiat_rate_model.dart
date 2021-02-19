class FiatRateModel {
  final Map<String, double> ratesPerUSD;

  FiatRateModel(this.ratesPerUSD);

  factory FiatRateModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return FiatRateModel(Map<String, double>.from(json["rates"]));
    } else {
      return FiatRateModel(null);
    }
  }

  double usdTo(double usdValue, String currency) {
    double rate = ratesPerUSD[currency];
    assert(rate != null);
    return usdValue * rate;
  }

  double toUSD(double currencyValue, String currency) {
    double rate = ratesPerUSD[currency];
    assert(rate != null);
    return rate > 0 ? currencyValue / rate : 0;
  }
}
