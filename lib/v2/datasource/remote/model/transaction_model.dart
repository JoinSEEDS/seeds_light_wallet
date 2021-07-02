class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String transactionId;

  String get symbol => quantity.split(" ")[1];

  TransactionModel(this.from, this.to, this.quantity, this.memo, this.timestamp, this.transactionId);

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      json['act']['data']['from'],
      json['act']['data']['to'],
      json['act']['data']['quantity'],
      json['act']['data']['memo'],
      json['@timestamp'],
      json['trx_id'],
    );
  }

  factory TransactionModel.fromJsonMongo(Map<String, dynamic> json) {
    return TransactionModel(
      json['act']['data']['from'],
      json['act']['data']['to'],
      json['act']['data']['quantity'],
      json['act']['data']['memo'],
      json['block_time'],
      json['trx_id'],
      //json["block_num"], // can add this later - neat but changes cache structure
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          from == other.from &&
          to == other.to &&
          quantity == other.quantity &&
          memo == other.memo &&
          transactionId == other.transactionId;
}