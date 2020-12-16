import 'package:flutter/foundation.dart';

enum Currency { SEEDS, USD }

extension CurrencyExtension on Currency {
  String get name => describeEnum(this);
}

Currency fromCurrencyName(String name) {
  switch (name) {
    case "SEEDS":
      return Currency.SEEDS;
    case "USD":
      return Currency.USD;
    default:
      return Currency.SEEDS;
  }
}
