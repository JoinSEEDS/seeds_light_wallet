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

  // full precision formatted string, can be used for chain calls, example "10.0000 SEEDS"
  String asFormattedString() {
    return "${amount.toStringAsFixed(precision)} $symbol";
  }

  // formatted number, no symbol, example "10.00"
  String amountString() {
    return amount.seedsFormatted;
  }

  // number and symbol, for display purposes, example "10.00 SEEDS"
  String amountStringWithSymbol() {
    return "${amount.seedsFormatted} $symbol";
  }
}
