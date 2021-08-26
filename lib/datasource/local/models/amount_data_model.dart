import 'package:seeds/utils/double_extension.dart';

abstract class AmountDataModel {
  final double amount;
  final String symbol;
  final int precision;

  AmountDataModel({
    required this.amount,
    required this.symbol,
    this.precision = 4,
  });

  // full precision formatted string, can be used for chain calls
  String asFormattedString() {
    return "${amount.toStringAsFixed(precision)} $symbol";
  }

  // only the number
  String amountString() {
    return amount.seedsFormatted;
  }

  // number and symbol, for display purposes
  String amountStringWithSymbol() {
    return "${amount.seedsFormatted}${" $symbol"}";
  }
}
