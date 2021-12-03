import 'dart:math';
import 'package:seeds/datasource/remote/model/token_model.dart';

/// Token per USD
class RateModel {
  final String tokenSymbol;
  final double tokensPerUSD;

  const RateModel(this.tokenSymbol, this.tokensPerUSD);

  double? tokenToUSD(double seedsAmount) {
    return tokensPerUSD > 0 ? seedsAmount / tokensPerUSD : null;
  }

  double? usdToToken(double usdAmount) {
    return tokensPerUSD > 0 ? usdAmount * tokensPerUSD : null;
  }

  factory RateModel.fromSeedsJson(Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final value = json['rows'][0]['current_seeds_per_usd'] ?? 0.toString();
      final amount = double.parse(value.split(' ').first);
      return RateModel(seedsToken.symbol, amount);
    } else {
      return RateModel(seedsToken.symbol, 0);
    }
  }

  factory RateModel.fromOracleJson(String tokenSymbol, int precision, Map<String, dynamic>? json) {
    if (json != null && json['rows'].isNotEmpty) {
      final int value = json['rows'][0]['median'] ?? 0;
      final double amount = value / pow(10, precision).toDouble();
      return RateModel(tokenSymbol, amount);
    } else {
      return RateModel(tokenSymbol, 0);
    }
  }
}
