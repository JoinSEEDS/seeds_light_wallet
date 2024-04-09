import 'package:equatable/equatable.dart';
import 'package:seeds/datasource/remote/model/generic_transaction_model.dart';
import 'package:seeds/utils/read_times_tamp.dart';
import 'package:seeds/utils/string_extension.dart';

class TransactionModel extends Equatable {
  final String from;
  final String to;
  final String quantity;
  final String memo;
  final DateTime timestamp;
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
      from: json['act']['data']['from'] as String,
      to: json['act']['data']['to'] as String,
      quantity: json['act']['data']['quantity'] as String,
      memo: json['act']['data']['memo'] as String,
      timestamp: parseTimestamp(json['@timestamp'] as String),
      transactionId: json['trx_id'] as String,
    );
  }

  factory TransactionModel.fromJsonMongo(Map<String, dynamic> json) {
    return TransactionModel(
      from: json['act']['data']['from'] as String,
      to: json['act']['data']['to'] as String,
      quantity: json['act']['data']['quantity'] as String,
      memo: json['act']['data']['memo'] as String,
      timestamp: parseTimestamp(json['block_time'] as String),
      transactionId: json['trx_id'] as String?,
      //json["block_num"], // can add this later - neat but changes cache structure
    );
  }

  static TransactionModel? fromTransaction(GenericTransactionModel genericModel) {
    if (genericModel.transaction.isTransfer) {
      final action = genericModel.transaction.actions.first;
      final data = action.data;
      final String? from = data?['from'] as String?;
      final String? to = data?['to'] as String?;
      final String? quantity = data?['quantity'] as String?;
      final String memo = data?['memo'] as String? ?? "";
      if (from != null && to != null && quantity != null) {
        return TransactionModel(
          from: from,
          to: to,
          quantity: quantity,
          memo: memo,
          timestamp: genericModel.timestamp ?? DateTime.now().toUtc(),
          transactionId: genericModel.transactionId,
        );
      }
    }

    return null;
  }
}
