class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String transactionId;

  TransactionModel(this.from, this.to, this.quantity, this.memo, this.timestamp,
      this.transactionId);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json["act"]["data"]["from"],
      json["act"]["data"]["to"],
      json["act"]["data"]["quantity"],
      json["act"]["data"]["memo"],
      json["@timestamp"],
      json["trx_id"],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          from == other.from &&
          to == other.to &&
          quantity == other.quantity &&
          memo == other.memo;

  @override
  int get hashCode => super.hashCode;
}

class ResourcesModel {
  final String netWeight;
  final String cpuWeight;
  final int ramBytes;

  ResourcesModel({this.netWeight, this.cpuWeight, this.ramBytes});

  factory ResourcesModel.fromJson(Map<String, dynamic> json) {
    return ResourcesModel(
      cpuWeight: json["cpu_weight"],
      netWeight: json["net_weight"],
      ramBytes: json["ram_bytes"],
    );
  }
}

class BalanceModel {
  final String quantity;

  BalanceModel(this.quantity);

  factory BalanceModel.fromJson(List<dynamic> json) {
    if (json != null && json.isNotEmpty) {
      return BalanceModel(json[0] as String);
    } else {
      return BalanceModel("0.0000 TLOS");
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceModel && quantity == other.quantity;

  @override
  int get hashCode => super.hashCode;
}