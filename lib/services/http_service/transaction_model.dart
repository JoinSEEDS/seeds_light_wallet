
class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;

  TransactionModel(this.from, this.to, this.quantity, this.memo);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json["from"],
      json["to"],
      json["quantity"],
      json["memo"],
    );
  }
}