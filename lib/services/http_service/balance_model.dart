class BalanceModel {
  final String quantity;

  BalanceModel(this.quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    return BalanceModel(json[0] as String);
  }
}