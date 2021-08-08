import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String transactionId;

  String get symbol => quantity.split(" ")[1];

  const TransactionModel(
      {required this.from,
      required this.to,
      required this.quantity,
      required this.memo,
      required this.timestamp,
      required this.transactionId});

  @override
  List<Object?> get props => [transactionId];

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

  factory TransactionModel.fromTxData(Map<String, dynamic> data, String transactionId) {
    return TransactionModel(
      from: data['from'],
      to: data['to'],
      quantity: data['quantity'],
      memo: data['memo'],
      timestamp: '0',
      transactionId: transactionId,
    );
  }
}
