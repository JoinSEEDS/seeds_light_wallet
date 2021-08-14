import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/remote/model/custom_transaction_model.dart';
import 'package:seeds/v2/utils/string_extension.dart';

class TransactionModel extends Equatable {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final String timestamp;
  final String? transactionId;

  String get symbol => quantity.split(" ")[1];
  double get doubleQuantity => quantity.quantityAsDouble;

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

  static TransactionModel? fromTransaction(CustomTransactionModel customModel) {
    if (customModel.action == "transfer") {
      final data = customModel.data;
      final String? from = data['from'];
      final String? to = data['to'];
      final String? quantity = data['quantity'];
      final String memo = data['memo'] ?? "";
      final String timestamp = "0";
      if (from != null && to != null && quantity != null) {
        return TransactionModel(
          from: from,
          to: to,
          quantity: quantity,
          memo: memo,
          timestamp: timestamp,
          transactionId: customModel.transactionId,
        );
      }
    }

    return null;
  }

  factory TransactionModel.fromTxDa1ta(Map<String, dynamic> data, String transactionId) {
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
