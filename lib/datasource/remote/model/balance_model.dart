/// The available balance of seeds
class BalanceModel {
  final double quantity;
  final bool hasBalance;

  const BalanceModel(this.quantity, {this.hasBalance = true});

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json.isEmpty || json[0] is! String) {
      return const BalanceModel(0, hasBalance: false);
    } else {
      final amount = double.parse((json[0] as String).split(' ').first);
      return BalanceModel(amount);
    }
  }
}
