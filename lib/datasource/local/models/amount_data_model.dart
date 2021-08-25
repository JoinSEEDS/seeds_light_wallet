abstract class AmountDataModel {
  final double amount;
  final String symbol;
  final int precision;

  AmountDataModel({
    required this.amount,
    required this.symbol,
    this.precision = 4,
  });

  String asFormattedString() {
    return "${amount.toStringAsFixed(precision)} $symbol";
  }
}
