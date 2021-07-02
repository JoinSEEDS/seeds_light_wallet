class TransactionModel {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String transactionId;

  String get symbol => quantity.split(" ")[1];

  TransactionModel({required this.from, required this.to, required this.quantity, required this.memo, required this.timestamp, required this.transactionId});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      from: json['act']['data']['from'],
      to: json['act']['data']['to'],
      quantity: json['act']['data']['quantity'],
      memo: json['act']['data']['memo'],
      timestamp: json['@timestamp'],
      transactionId: json['trx_id'],
    );
  }

  factory TransactionModel.fromJsonMongo(Map<String, dynamic> json) {
    return TransactionModel(
      from: json['act']['data']['from'],
      to: json['act']['data']['to'],
      quantity: json['act']['data']['quantity'],
      memo: json['act']['data']['memo'],
      timestamp: json['block_time'],
      transactionId: json['trx_id'],
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