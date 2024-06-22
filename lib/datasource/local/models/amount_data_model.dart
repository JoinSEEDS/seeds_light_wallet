abstract class AmountDataModel {
  final double amount;
  final String symbol;
  final int? precision;
  final int defaultPrecision = 4;

  AmountDataModel({
    required this.amount,
    required this.symbol,
    this.precision,
  });

  // full precision formatted string, can be used for chain calls, example "10.0000 SEEDS"
  String asFormattedString() {
    return "${amount.toStringAsFixed(precision ?? defaultPrecision)} $symbol";
  }

  // full precision string without symbol, e.g. "10.0000"
  String asFixedString() {
    return amount.toStringAsFixed(precision ?? defaultPrecision);
  }
}
