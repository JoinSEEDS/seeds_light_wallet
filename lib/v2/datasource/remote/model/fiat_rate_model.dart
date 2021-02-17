class FiatRateModel {
  final Map<String, double> ratesPerUSD;
  final bool error;

  List<String> get currencies {
    var list = List<String>.from(ratesPerUSD.keys);
    list.sort();
    return list;
  }

  FiatRateModel(this.ratesPerUSD, {this.error = false});

  factory FiatRateModel.fromJson(Map<String, dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return FiatRateModel(new Map<String, double>.from(json["rates"]));
    } else {
      return FiatRateModel(null, error: true);
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
