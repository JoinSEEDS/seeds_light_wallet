/// The available balance of seeds
class BalanceModel {
  final double quantity;
  final bool hasBalance;
  final int precision;

  const BalanceModel(this.quantity, this.precision, {this.hasBalance = true});

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isEmpty || json[0].isEmpty) {
      return const BalanceModel(0, 0, hasBalance: false);
    } else {
      final amountString = (json[0] as String).split(' ').first;
      final amount = double.parse(amountString);
      final decimalPointIndex = amountString.indexOf(".");
      final precision = decimalPointIndex != -1 ? amountString.substring(decimalPointIndex).length - 1 : 0;
      return BalanceModel(amount, precision);
    }
  }
}
