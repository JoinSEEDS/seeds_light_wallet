
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

}
