import 'dart:math';

/// Token per USD
class RateModel {
  final String tokenId;
  final double tokensPerUSD;

  const RateModel(this.tokenId, this.tokensPerUSD);

  double? tokenToUSD(double seedsAmount) {
    return tokensPerUSD > 0 ? seedsAmount / tokensPerUSD : null;
  }

  double? usdToToken(double usdAmount) {
    return tokensPerUSD > 0 ? usdAmount * tokensPerUSD : null;
  }

  factory RateModel.fromSeedsJson(Map<String, dynamic>? json) {
    const seedsTokenId = 'Telos#token.seeds#SEEDS';
    if (json != null && (json['rows'] as List).isNotEmpty) {
      final value = json['rows'][0]['current_seeds_per_usd'] ?? 0.toString();
      final amount = double.parse(value.split(' ').first as String);
      return RateModel(seedsTokenId, amount);
    } else {
      return const RateModel(seedsTokenId, 0);
    }
  }

  factory RateModel.fromOracleJson(String tokenId, int precision, Map<String, dynamic>? json) {
    if (json != null && (json['rows'] as List).isNotEmpty) {
      print("JSON $json");
      final int value = json['rows'][0]['median'] as int? ?? 0;
      final double amount = value / pow(10, precision).toDouble();
      return RateModel(tokenId, 1 / amount);
    } else {
      return RateModel(tokenId, 0);
    }
  }
}
