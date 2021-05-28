/// The current SEEDS per USD
class RateModel {
  final double seedsPerUSD;

  const RateModel(this.seedsPerUSD);

  double toUSD(double seedsAmount) {
    return seedsPerUSD > 0 ? seedsAmount / seedsPerUSD : 0;
  }

  double toSeeds(double usdAmount) {
    return seedsPerUSD > 0 ? usdAmount * seedsPerUSD : 0;
  }

  factory RateModel.fromJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      var value = json['rows'][0]['current_seeds_per_usd'] ?? 0.toString();
      var amount = double.parse(value.split(' ').first);
      return RateModel(amount);
    } else {
      return const RateModel(0);
    }
  }
}
