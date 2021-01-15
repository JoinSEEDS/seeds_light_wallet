import 'package:flutter/foundation.dart';

enum Currency { SEEDS, FIAT }

extension CurrencyExtension on Currency {
  String get name => describeEnum(this);
}

Currency fromCurrencyName(String name) {
  switch (name) {
    case "SEEDS":
      return Currency.SEEDS;
    case "FIAT":
      return Currency.FIAT;
    default:
      return Currency.SEEDS;
  }
}
